// Ư������, �̸�Ƽ�� ��ũ��Ʈ

function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring()(p+1)].document; n=n.substring()(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}

function OnCheckPhone(oTa) {
	var oForm = oTa.form ;
	var onlynum = "" ;
	var substr = "";
	onlynum = oForm.phone123.value;

	if (GetMsgLen(onlynum) == 3)
	{
		if (onlynum == '011' || onlynum =='016' || onlynum == '017' || onlynum == '018' || onlynum == '019' || onlynum =='013')
		{

		}
		else
		{
			alert('��ȿ���� ���� ��Ż� ��ȣ�Դϴ�.\n\n011 ~ 019, 0130 �� �Է��ϼ���.');
			oTa.value = '';
			return;
		}
	}
	if (GetMsgLen(onlynum) == 4)
	{
		substr = onlynum.substring(0,3);

		if (substr != '011' && substr != '016' && substr != '017' && substr != '018' && substr != '019' && onlynum != '0130'){
			alert('��ȿ���� ���� ��Ż� ��ȣ�Դϴ�.\n\n011 ~ 019, 0130 �� �Է��ϼ���.');
			oTa.value = '';
			return;
		}
	}
}

function onlynum()
{
	if (((event.keyCode<48)||(event.keyCode>57)) && event.keyCode!=44)
		event.returnValue=false;
}

function GetMsgLen(sMsg)
{ // 0-127 1byte, 128~ 2byte
	var count = 0
	for(var i=0; i<sMsg.length; i++)
	{
		if ( sMsg.charCodeAt(i) > 127 ) 
		{			
			count += 2
		}
		else {
			count++
		}
	}
	return count
}

function SelText()
{
 	if (document.visual_phone.txtMessage.value == "�������� ������ ��� ��ǥ(,)�� �̿��Ͽ� �Է����ּ���.")
 	{
   		document.visual_phone.txtMessage.value = "";
 	}
	document.visual_phone.txtMessage.msglen = 0;
}

//�޽��� �Է½� string() ���� üũ
function checklen()
{
	var msgtext, msglen;
	
	msgtext = document.visual_phone.txtMessage.value;
	msglen = document.visual_phone.msglen.value;
	
	var i=0,l=0;
	var temp,lastl;
	
	//���̸� ���Ѵ�.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>80)
		{
			alert("�޽������� ��� ���� �̻��� ���� ���̽��ϴ�.\n �޽��������� �ѱ� 40��, ����80�ڱ����� ���� �� �ֽ��ϴ�.");
			temp = document.visual_phone.txtMessage.value.substr(0,i);
			document.visual_phone.txtMessage.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	visual_phone.msglen.value=l;
}

function resv_divopen() 
{	
	if (document.visual_phone.calltype.checked == true) 
	{
		document.all["divResv"].style.display = "";	
	} 
	else  
	{
		document.all["divResv"].style.display = "none";	
	}
}

function Check()
{
	var i;
	var form;
	form = document.visual_phone;
	
	if(navigator.appVersion.indexOf("MSIE 5") != -1 || navigator.appVersion.indexOf("MSIE 6") != -1){
		if(document.visual_phone.txtMessage.value.length == 0 || document.visual_phone.txtMessage.value == "<�޽����� ���⿡ �Է����ּ���>")
		{
			alert("�޽����� �Է� ���ּ���");
			SelText();
			document.visual_phone.txtMessage.focus();
			return ;
		}
	}

	for (i=0; i<document.visual_phone.reqnumber.value.length;i++)
		{
			if (document.visual_phone.reqnumber.value.charCodeAt(i) < 48 || document.visual_phone.reqnumber.value.charCodeAt(i) > 57)
			{
				alert("Ư�����ڰ� �����ϴ�.");
				document.visual_phone.reqnumber.focus();
				return ;
			}
	}

	if(form.phone123.value == "")	
	{
		alert("������ ��ȣ�� �־��ּ���");
		form.phone123.focus();
		return;
	}

	if(GetMsgLen(form.phone123.value) > 11 || GetMsgLen(form.phone123.value) < 10)
	{
		alert("������ ��ȣ�� ���̰� ��ų� ª���ϴ�.");
		form.phone123.focus();
		return;
	}
	
	if(document.visual_phone.calltype.checked == true)
	{
		var time = new Date();
		//���� üũ
		var leap_year = 0;
		if( (!(Number(form.yy.value)%4) && Number(form.yy.value)%100) || !(Number(form.yy.value)%400) )
		{
			leap_year=1;		//�����϶�..
		}
		if(form.yy.value.length == 0) {
			alert("�⵵�� �Է��ϼ���.");
			form.yy.focus();
			return;
		}
		if(isKindStr(form.yy.value) == false) {
			alert("�⵵�� ��Ȯ�ϰ� �Է��ϼ���.");
			document.visual_phone.yy.focus();
			return ;
		}
		if(form.mm.value.length == 0) {
			alert("���� �Է��ϼ���.");
			document.visual_phone.mm.focus();
			return ;
		}
		if(isKindStr(form.mm.value) == false) {
			alert("���� ��Ȯ�ϰ� �Է��ϼ���.");
			document.visual_phone.mm.focus();
			return ;
		}
		if(form.mm.value < 1 || form.mm.value > 12) {
			alert("���� ��Ȯ�ϰ� �Է��ϼ���(1��12).");
			document.visual_phone.mm.focus();
			return ;
		}
		if(form.dd.value.length == 0) {
			alert("���ڸ� �Է��ϼ���.");
			document.visual_phone.dd.focus();
			return ;
		}
		if(isKindStr(form.dd.value) == false) {
			alert("���ڸ� ��Ȯ�ϰ� �Է��ϼ���.");
			document.visual_phone.dd.focus();
			return ;
		}
// 2�� üũ�ϴºκ�...
		if(form.mm.value == 2 && (form.dd.value < 1 || form.dd.value > (28 + Number(leap_year)))) {
			alert("���ڸ� ��Ȯ�ϰ� �Է��ϼ���. (1��"+(28 + Number(leap_year))+").");
			document.visual_phone.dd.focus();
			return ;
		}
// 30�ϱ��� �ִ� �� üũ
		if( (form.mm.value == 4 || form.mm.value == 6 || form.mm.value == 9 || form.mm.value == 11 ) && (form.dd.value < 1 || form.dd.value > 30) ){
			alert("���ڸ� ��Ȯ�ϰ� �Է��ϼ���(1��30).");
			document.visual_phone.dd.focus();
			return ;
		}
// 31�ϱ��� �ִ� �� üũ
		else if(form.dd.value < 1 || form.dd.value > 31) {
			alert("���ڸ� ��Ȯ�ϰ� �Է��ϼ���(1��31).");
			document.visual_phone.dd.focus();
			return ;
		}
		if(form.h.value.length == 0) {
			alert("�ð��� �Է��ϼ���.");
			document.visual_phone.h.focus();
			return ;
		}
		if(isKindStr(form.h.value) == false) {
			alert("�ð��� ��Ȯ�ϰ� �Է��ϼ���.");
			document.visual_phone.h.focus();
			return ;
		}
		if(form.h.value < 0 || form.h.value > 23) {
			alert("�ð��� ��Ȯ�ϰ� �Է��ϼ���.(00��23).");
			document.visual_phone.h.focus();
			return ;
		}
		if(form.m.value.length == 0) {
			alert("�ð��� �Է��ϼ���.");
			document.visual_phone.m.focus();
			return ;
		}
		if(isKindStr(form.m.value) == false) {
			alert("�ð��� ��Ȯ�ϰ� �Է��ϼ���.");
			document.visual_phone.m.focus();
			return ;
		}
		if(form.m.value < 0 || form.h.value > 59) {
			alert("�ð��� ��Ȯ�ϰ� �Է��ϼ���.(00��59).");
			document.visual_phone.m.focus();
			return ;
		}
		if(Number(form.yy.value) < Number(form.current_yy.value)) {
			alert("���� ������ ������ �Է��ϼ���.");
			document.visual_phone.yy.focus();
			return ;
		}
		else { 
			if((Number(form.yy.value) == Number(form.current_yy.value)) && (Number(form.mm.value) < Number(form.current_mm.value))) {
				alert("���� ������ ���� �Է��ϼ���.");
				document.visual_phone.mm.focus();
				return ;
			}
			else {
				if((Number(form.yy.value) == Number(form.current_yy.value)) && (Number(form.mm.value) == (Number(form.current_mm.value))) && (Number(form.dd.value) < Number(form.current_dd.value))) {
					alert("���� ������ ���ڸ� �Է��ϼ���.");
					document.visual_phone.dd.focus();
					return ;
				}
				else {
					if((Number(form.yy.value) == Number(form.current_yy.value)) && (Number(form.mm.value) == (Number(form.current_mm.value))) && (Number(form.dd.value) == Number(form.current_dd.value)) && (Number(form.h.value) < Number(form.current_h.value))) {
						alert("���� ������ �ð��� �Է��ϼ���.");
						document.visual_phone.h.focus();
						return ;
					}
					else {
						if((Number(form.yy.value) == Number(form.current_yy.value)) && (Number(form.mm.value) == (Number(form.current_mm.value))) && (Number(form.dd.value) == Number(form.current_dd.value)) && (Number(form.h.value) == Number(form.current_h.value)) && (Number(form.m.value) < Number(form.current_m.value))) {
							alert("���� ������ �ð�(��)�� �Է��ϼ���.");
							document.visual_phone.m.focus();
							return ;
						}
					}
				}
			}
		}
	}

	if(navigator.appVersion.indexOf("MSIE 5") != -1 || navigator.appVersion.indexOf("MSIE 6") != -1){
		if(confirm('�޽��� :\n'+document.visual_phone.txtMessage.value+'\n'+'�޴»�� : '+  document.visual_phone.phone123.value +  '\n\n�����Ͻðڽ��ϱ�??'))
		{
			document.visual_phone.action='smscall2.asp';
			document.visual_phone.submit();
		}
		else
		{
			return;
		}
	}
	else{
		if(confirm('�޽��� :\n'+document.visual_phone.txtMessage.value+'\n'+'�޴»�� : '+  document.visual_phone.phone123.value +  '\n\n�����Ͻðڽ��ϱ�??'))
		{
			document.visual_phone.action='smscall2.asp';
			document.visual_phone.submit();
		}
		else
		{
			return;
		}
	}
}

function AddChar(ch)
{
	var t;
	var msglen;
	var tempstr;
	msglen = 0;
	if (document.visual_phone.txtMessage.value == "�������� ������ ��� ��ǥ(,)�� �̿��Ͽ� �Է����ּ���.")
	{
			document.visual_phone.txtMessage.value = "";
			document.visual_phone.txtMessage.msglen = 0;
	}
	document.visual_phone.txtMessage.value = document.visual_phone.txtMessage.value + ch;
	tempstr = document.visual_phone.txtMessage.value;
	l = document.visual_phone.txtMessage.value.length;
	for(k=0;k<l;k++){
	t = document.visual_phone.txtMessage.value.charAt(k);
	if (escape(t).length > 4)
		msglen += 2;
	else
		msglen++;
	}
	if (msglen>80)
	{
		alert("������ ��� ���� �̻��� ���� ���̽��ϴ�.\n �������� �ѱ� 40��, ����80�ڱ����� ���� �� �ֽ��ϴ�.");
		cut_text(tempstr);
	}
	document.visual_phone.msglen.value = msglen;
}

function isKindStr(str)
{
   for (i = 0; i < str.length; i++) 
   {
	if (('0' <= str.charAt(i))&&(str.charAt(i) <= '9')){
		 continue;
	}
	else {
		 return false;
	}
  }
  return true;
}