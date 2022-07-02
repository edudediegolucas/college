-- gnutelight_handler.ads


with Lower_Layer_UDP;
with Ada.Strings.Unbounded;
with Gnutelight_Contacts;

package Gnutelight_Handler is

procedure My_Handler(From:       in Lower_Layer_UDP.End_Point_Type;
                        To:         in Lower_Layer_UDP.End_Point_Type;
                    Buff_A: access Lower_Layer_UDP.Buffer_Type);

Directorio: Ada.Strings.Unbounded.Unbounded_String;
contactos:Gnutelight_Contacts.Contacts_List_Type;

end Gnutelight_Handler;
