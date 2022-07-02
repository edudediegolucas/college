-- $Id: concurrency.ads,v 1.7 1997/08/22 10:47:11 jgb Exp $
--

-- ADTs useful in concurrency control.

with Ada.Task_Identification;

package Concurrency is

   ------------------------------------------------------------------
   -- Mutex type.
   -- !!!: In case a task holding the mutex calls Enter,
   --      it enters and increments Owner_Count.
   --      When leaving, if Owner_Count > 0, just decrements it.
   ------------------------------------------------------------------

   protected type Mutex is

      -- We need the Id because we cannot call Current_Task
      --  within an entry
      entry    Enter;
      entry    Leave;
      function Image return String;
   private
      Count:       Natural := 1;
      Owner:       Ada.Task_Identification.Task_Id :=
        Ada.Task_Identification.Null_Task_Id;
      Owner_Count: Natural := 0;
   end Mutex;

   type Mutex_A is access Mutex;

   function Image (A_Mutex: in Mutex_A) return String;

   ------------------------------------------------------------------
   -- Semaphore type.
   ------------------------------------------------------------------

   protected type Semaphore is

      entry    Reset (A_Count: Natural := 0);
      entry    Wait;
      entry    Signal;
      function Image return String;

   private
      Count: Natural := 0;
   end Semaphore;

   type Semaphore_A is access all Semaphore;

   ------------------------------------------------------------------
   -- Timed_Wait
   --  Works like Wait in A_Semaphore, except that if timeout expires,
   --  returns inmediately.
   ------------------------------------------------------------------

   procedure Timed_Wait (A_Semaphore: in  Semaphore_A;
                         Timeout:     in  Duration;
                         Expired:     out Boolean);

   ------------------------------------------------------------------
   -- Timed_Wait (short version).
   ------------------------------------------------------------------

   procedure Timed_Wait (A_Semaphore: in  Semaphore_A;
                         Timeout:     in  Duration);

   function Image (A_Semaphore: in Semaphore_A) return String;

end Concurrency;
