<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, ax_hub.*" %>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>


<%	
	//������������������ �Ѿ����
	String am_ax_code 	= request.getParameter("var2")==null?"":request.getParameter("var2");
		
	AxHubBean ax_bean 	= ax_db.getAxHubCase(am_ax_code);

    	String ordr_idxx 	= ax_bean.getOrdr_idxx();
    	String tno 		= ax_bean.getTno();
    	int    good_mny 	= ax_bean.getGood_mny();
    	String good_name 	= ax_bean.getGood_name();
    	String buyr_name 	= ax_bean.getBuyr_name();
    	String buyr_tel1 	= ax_bean.getBuyr_tel1();
    	String buyr_tel2 	= ax_bean.getBuyr_tel2();
    	String buyr_mail 	= ax_bean.getBuyr_mail();
    	String card_name 	= ax_bean.getCard_name();
    	String quota 		= ax_bean.getQuota();    
    	
    	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<head>
    <title>*** Amazoncar ***</title>
    <link href="css/sample.css" rel="stylesheet" type="text/css">
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
    <script type="text/javascript">
    
        /* �ſ�ī�� ������ ���� ��ũ��Ʈ */
        function receiptView(tno)
        {
            receiptWin = "https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no=" + tno ;
            window.open(receiptWin , "" , "width=470, height=815") ;
        }
    </script>
</head>



<body>
<div align="center">
    <table width="589" cellspacing="0" cellpadding="0">
        <tr>
	    <td height=5></td>
	</tr>
	<tr>
	    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=img/logo_acc.gif></td>
	</tr>
	<tr>
	    <td height=6></td>
	</tr>
        <tr>
	    <td>
		<table width=589 cellspacing=0 cellpadding=0 border=0 background=img/acc_ask_bg.gif>
		    <tr>
			<td><img src=img/acc_rst_top.gif></td>
		    </tr>
		    <tr>
			<td height=15></td>
		    </tr>
                    <tr>
                	<td align=center>
			    <table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_10">
			        <tr><td colspan="2" class="title"><img src=img/acc_rst_bar2.gif></td></tr>
			        <!-- �ֹ���ȣ -->
			        <tr><td class="sub_title1">�ֹ� ��ȣ</td><td class="sub_content1"><%= ordr_idxx %></td></tr>
			        <!-- �����ݾ� -->
			        <tr><td class="sub_title1">���� �ݾ�</td><td class="sub_content1"><%= good_mny %>��</td></tr>
			        <!-- ��ǰ��(good_name) -->
			        <tr><td class="sub_title1">��ǰ��</td><td class="sub_content1"><%= good_name %></td></tr>
			        <!-- �ֹ��ڸ� -->
			        <tr><td class="sub_title1">�ֹ��ڸ�</td><td class="sub_content1"><%= buyr_name %></td></tr>
			        <!-- �ֹ��� ��ȭ��ȣ -->
			        <tr><td class="sub_title1">�ֹ��� ��ȭ��ȣ</td><td class="sub_content1"><%= buyr_tel1 %></td></tr>
			        <!-- �ֹ��� �޴�����ȣ -->
			        <tr><td class="sub_title1">�ֹ��� �޴�����ȣ</td><td class="sub_content1"><%= buyr_tel2 %></td></tr>
			        <!-- �ֹ��� E-mail -->
			        <tr><td class="sub_title1">�ֹ��� E-mail</td><td class="sub_content1"><%= buyr_mail %></td></tr>
			    </table>
			</td>
		    </tr>
                    <tr>
                	<td align=center>
			    <table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_20">
				<tr><td colspan="2" class="title"><img src=img/acc_rst_bar3.gif></td></tr>
				<!-- �������� : �ſ�ī�� -->
				<tr><td class="sub_title1">���� ����</td><td class="sub_content1">�ſ�ī��</td></tr>
				<!-- ���� ī�� -->
				<tr><td class="sub_title1">���� ī��</td><td class="sub_content1"><%=card_name%></td></tr>
				<!-- �Һΰ��� -->
				<tr><td class="sub_title1">�Һ� ����</td><td class="sub_content1"><%=quota%></td></tr>
			        <tr><td class="sub_title1">������ Ȯ��</td><td class="sub_content1"><a href="javascript:receiptView('<%=tno%>')"><img src="img/acc_btn_rcp.gif" alt="�������� Ȯ���մϴ�." /></td></tr>
			    </table>
			</td>
		    </tr>
                    <tr>
                	<td align=center>
			    <table width="90%" class="margin_top_10">
			        <tr><td style="text-align:center"><a href="javascript:window.close()"><img src="img/acc_btn_cls.gif" alt="�������� �ݽ��ϴ�." /></a></td></tr>
			    </table>
			</td>
		    </tr>
		</table>
            </td>
        </tr>
        <tr><td><img src=img/acc_ask_btm.gif></td></tr>
    </table>
    </div>
</body>
</html>

