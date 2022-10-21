<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, ax_hub.*" %>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>


<%	
	//결제연동페이지에서 넘어오기
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
    
        /* 신용카드 영수증 연동 스크립트 */
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
			        <!-- 주문번호 -->
			        <tr><td class="sub_title1">주문 번호</td><td class="sub_content1"><%= ordr_idxx %></td></tr>
			        <!-- 결제금액 -->
			        <tr><td class="sub_title1">결제 금액</td><td class="sub_content1"><%= good_mny %>원</td></tr>
			        <!-- 상품명(good_name) -->
			        <tr><td class="sub_title1">상품명</td><td class="sub_content1"><%= good_name %></td></tr>
			        <!-- 주문자명 -->
			        <tr><td class="sub_title1">주문자명</td><td class="sub_content1"><%= buyr_name %></td></tr>
			        <!-- 주문자 전화번호 -->
			        <tr><td class="sub_title1">주문자 전화번호</td><td class="sub_content1"><%= buyr_tel1 %></td></tr>
			        <!-- 주문자 휴대폰번호 -->
			        <tr><td class="sub_title1">주문자 휴대폰번호</td><td class="sub_content1"><%= buyr_tel2 %></td></tr>
			        <!-- 주문자 E-mail -->
			        <tr><td class="sub_title1">주문자 E-mail</td><td class="sub_content1"><%= buyr_mail %></td></tr>
			    </table>
			</td>
		    </tr>
                    <tr>
                	<td align=center>
			    <table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_20">
				<tr><td colspan="2" class="title"><img src=img/acc_rst_bar3.gif></td></tr>
				<!-- 결제수단 : 신용카드 -->
				<tr><td class="sub_title1">결제 수단</td><td class="sub_content1">신용카드</td></tr>
				<!-- 결제 카드 -->
				<tr><td class="sub_title1">결제 카드</td><td class="sub_content1"><%=card_name%></td></tr>
				<!-- 할부개월 -->
				<tr><td class="sub_title1">할부 개월</td><td class="sub_content1"><%=quota%></td></tr>
			        <tr><td class="sub_title1">영수증 확인</td><td class="sub_content1"><a href="javascript:receiptView('<%=tno%>')"><img src="img/acc_btn_rcp.gif" alt="영수증을 확인합니다." /></td></tr>
			    </table>
			</td>
		    </tr>
                    <tr>
                	<td align=center>
			    <table width="90%" class="margin_top_10">
			        <tr><td style="text-align:center"><a href="javascript:window.close()"><img src="img/acc_btn_cls.gif" alt="페이지를 닫습니다." /></a></td></tr>
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

