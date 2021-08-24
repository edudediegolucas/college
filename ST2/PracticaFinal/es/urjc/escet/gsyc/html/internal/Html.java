package PracticaFinal.es.urjc.escet.gsyc.html.internal;

public class Html extends HtmlElement {
	
	private HtmlElement title;
	private HtmlElement head;
	private HtmlElement body;
	
	public Html(){
		super(HTML_TAG);
		title = new HtmlElement(TITLE_TAG);
		head = new HtmlElement(HEAD_TAG);
		body = new HtmlElement(BODY_TAG);
		
		head.addChild(title);
		this.addChild(head);
		this.addChild(body);
	}
	
	public void setTile(String title){
		this.title.addChild(new HtmlText(title));
	}
	
	public HtmlP addP(){
		HtmlP p = new HtmlP();
		this.addChild(p);
		return p;
	}

	public void addHr(){
		HtmlHr hr = new HtmlHr();
		this.addChild(hr);
	}
	
	public void addBr(){
		HtmlBr br = new HtmlBr();
		this.addChild(br);
	}
	
	public void addText(String text){
		HtmlText t = new HtmlText(text);
		this.addChild(t);
	}
	
	public HtmlA addA(String destination, String text){
		HtmlA anchor = new HtmlA(destination, text);
		this.addChild(anchor);
		return anchor;
	}
	
	public HtmlForm addForm(String target){
		HtmlForm form = new HtmlForm(target);
		this.addChild(form);
		return form;
	}
	
	public HtmlTable addTable(){
		HtmlTable table = new HtmlTable();
		this.addChild(table);
		return table;
	}
	
	public StringBuilder getPage(){
		return this.build();
	}
	public void addInputText(String name){
		HtmlClosedElement input = new HtmlClosedElement(INPUT);
		input.addAttribute(TYPE, TEXT);
		input.addAttribute(NAME, name);
		this.addChild(input);
	}
	public void addInputText(String name, String value){
		HtmlClosedElement input = new HtmlClosedElement(INPUT);
		input.addAttribute(TYPE, TEXT);
		input.addAttribute(NAME, name);
		input.addAttribute(VALUE, value);
		this.addChild(input);
	}
	public void addInputPassword(String name){
		HtmlClosedElement input = new HtmlClosedElement(INPUT);
		input.addAttribute(TYPE, PASSWORD);
		input.addAttribute(NAME, name);
		this.addChild(input);
	}
	public void addInputSubmit(String value){
		HtmlClosedElement input = new HtmlClosedElement(INPUT);
		input.addAttribute(TYPE, SUBMIT);
		input.addAttribute(VALUE, value);
		this.addChild(input);
	}
	public void addInputReset(String value){
		HtmlClosedElement input = new HtmlClosedElement(INPUT);
		input.addAttribute(TYPE, RESET);
		input.addAttribute(VALUE, value);
		this.addChild(input);
	}
}
