<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, ax_hub.*" %>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>


<%
	//�������� �α���������
	
	
	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");

	
	String login_yn = "";
	
			
	if(!var1.equals("") && !var2.equals("")){
		
		//������ȣ Ȯ��
		
		String code = ax_db.getSearchVarCode(var1, var2); 
				
		if(code.equals(var2)){
		
			login_yn = "r_ok";
			
			AxHubBean ax_bean = ax_db.getAxHubCase(var2);
			
		
			//��ó��Ȯ��		
			if(!ax_bean.getTno().equals("")){
				login_yn = "end";
			}			
			
			
			
		}else{
			if(code.equals("error")){
				login_yn = "db_error";
			}else{
				login_yn = "no_id";
			}
		}
		
		String login_time 	= Util.getLoginTime();//�α��νð�
		
		System.out.println("[������ȣ �α���] DT:"+login_time+", M_TEL:"+var1+", NUM:"+var2);				
				
	}
	
		

%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>Amazoncar ��������</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type=text/css>

<!--
.style1 {color: #061646;
         font-size: 11px;}
.style2 {color: #ee5d00;
         font-size: 11px;}
}
-->

</style>
</head>
<SCRIPT LANGUAGE="Javascript">
<!--
var isNS = (navigator.appName == "Netscape") ? 1 : 0;
var EnableRightClick = 0;
if(isNS) 
document.captureEvents(Event.MOUSEDOWN||Event.MOUSEUP);

function mischandler(){
  if(EnableRightClick==1){ return true; }
  else {return false; }
}

function mousehandler(e){
  if(EnableRightClick==1){ return true; }
  var myevent = (isNS) ? e : event;
  var eventbutton = (isNS) ? myevent.which : myevent.button;
  if((eventbutton==2)||(eventbutton==3)) return false;
}

function keyhandler(e) {
  var myevent = (isNS) ? e : window.event;
  if (myevent.keyCode==96)
    EnableRightClick = 1;
  return;
}

document.oncontextmenu = mischandler;
document.onkeypress = keyhandler;
document.onmousedown = mousehandler;
document.onmouseup = mousehandler;
//-->
</script>
<script language="JavaScript" src="/include/info_axhub.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function EnterDown(idx){
		var keyValue = event.keyCode;
		if (keyValue =='13') submitgo(idx);
	}

	function submitgo(){
   		var fm = document.form1;
		if(fm.var1.value=="")	{   	alert("�޴�����ȣ�� �Է��Ͻʽÿ�.");   		fm.var1.focus();  return;	}	
		if(fm.var2.value=="")	{   	alert("����������ȣ�� �Է��Ͻʽÿ�.");   	fm.var2.focus();  return;	}	
		fm.action = 'index.jsp';
   		fm.submit();
	}
//-->
</SCRIPT>


<BODY bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" 
<%	if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_ok")){	//����%>
	onLoad="javascript:OpenAmazonCAR('1');"
<%	}else if(login_yn.equals("end")){	//�̹�ó���ȹ�ȣ%>
	onLoad="javascript:OpenAmazonCAR('3');"
<%	}else if(login_yn.equals("db_error")){	//����%>
	onLoad="javascript:OpenAmazonCAR('2');"
<%	}else if(login_yn.equals("no_id")){	//����ID%>
	onLoad="javascript:OpenAmazonCAR('0');"
<%	}else{%>
	onLoad="javascript:document.form1.var1.focus();"
<%	}%>
>

<table width=100% border=0 cellspacing=0 cellpadding=0 align=center>
<form name="form1" action="index.jsp" method="post">
	<tr>
        <td height=30></td>
	</tr>
	<tr>
		<td height=6></td>
	</tr>
	<tr>
		<td height=6></td>
	</tr>
	<tr>
		<td align=center><h3>�ش� �������񽺸� ���̻� �������� �ʽ��ϴ�.</h3></td>
    </tr>
	<tr>
		<td align=center><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
	
<!--
	<tr>
		<td>
      		<table width=453 border=0 cellpadding=0 cellspacing=0 background=img/acc_bg.gif>
            	<tr>
                 	<td align=center>
                      	<table width=337 border=0 cellspacing=0 cellpadding=0>
                        	<tr>
                        		<td height=90></td>
                        	</tr>
                      		<tr>
                        		<td width=87>�޴�����ȣ</td>
                       			<td width=154><input type="text" name="var1" value="<%=var1%>" size=20 class=text tabindex=1></td>
                        		<td width=96 rowspan=2><a href="javascript:submitgo()"><img src=img/acc_btn_conf.gif border="0"></a></td>
                       		</tr>
                   			<tr>
                        		<td>������ȣ</td>
                        		<td><input type="text" name="var2" value="<%=var2%>" size=20 class=text onKeydown="EnterDown(2)" tabindex=1></td>
                     		</tr>
                      		<tr>
                        		<td height=30></td>
                   			</tr>
                  		</table>
               		</td>
           		</tr>
            	<tr>
                 	<td height=76 align=center><span class=style1>�޴�����ȣ�� ���ڷ� ���� ������ȣ�� �Է��Ͻ� �� '<span class=style2>Ȯ�ι�ư</span>'�� �����ʽÿ�.</span></td>
              	</tr>
            </table>
        </td>
    </tr>
	-->
</form>		
</table>
</body>
</html>
