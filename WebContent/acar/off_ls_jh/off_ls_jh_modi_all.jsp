<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="auction_ban" class="acar.offls_actn.Offls_auction_banBean" scope="page"/>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String 	 auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] pr_arr 		= request.getParameterValues("pr");
%>
<html>
<head>
<title>FMS - ��ų��� �ϰ����� �˾�</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
function updAuctDtCnt(){
	if($("#actn_dt").val()=="" || $("#actn_dt").val().length != 8){
		alert("������ڸ� �Է����ּ��� (���� 8�ڸ�)");
		$("#actn_dt").focus();
		return false;
	}else if($("#actn_cnt").val()==""){
		alert("���ȸ���� �Է����ּ���.");
		$("#actn_cnt").focus();
		return false;
	}else{
		if(confirm("���� ������ȣ�� �����, ���ȸ���� �ϰ������˴ϴ�.\n\n���� �ϰ����� �Ͻðڽ��ϱ�?")){
			var fm = form1;
			window.open('','pop_target_a','width=700, height=600, top=0, left=0, resizable=no, status=no, menubar=no, toolbar=no, scrollbars=yes, location=no');
			fm.target = "pop_target_a";
			fm.method = 'POST';
			fm.action = "off_ls_jh_modi_all_a.jsp";
			fm.submit();
		}else{	return false;	}
	}
}
</script>
</head>
<body>
<form name="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<table border=0 cellspacing=0 cellpadding=0 width="660">
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>��ǰ��Ȳ > <span class=style5>��ų��� �ϰ�����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
		</td>
	</tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top: 20px;">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=660> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width=12% class='title'>������ȣ</td>
                                <td width=35% class='title'>����</td>
                                <td width=28% class='title'>�����</td>
                                <td width=15% class='title'>�������</td>
                                <td width=10% class='title'>���ȸ��</td>
                            </tr>
                        </table>
                    </td>
	            </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=660> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
	for(int i=0; i<pr_arr.length; i++){
		String car_mng_id = pr_arr[i].substring(0,6);
		String seq 		= olaD.getAuction_maxSeq(car_mng_id);
		olaBean 		= olaD.getActn_detail(car_mng_id);
		auction 		= olaD.getAuction(car_mng_id, seq);
%>	            
                            <tr>
                                <td width=12% align="center">
                                	<%=olaBean.getCar_no()%>
                                	
                                	<input type="hidden" name="actnParam" value="<%=car_mng_id%>//<%=auction.getSeq()%>">
                                </td>
                                <td width=35%>&nbsp;<%=AddUtil.subData(olaBean.getCar_jnm()+" "+olaBean.getCar_nm(),24)%></td>
                                <td width=28%>&nbsp;<%=AddUtil.subData(olaD.getActn_nm(olaBean.getActn_id()),15)%></td>
                                <td width=15% align="center"><%=AddUtil.ChangeDate2(olaBean.getActn_dt())%></td>
                                <td width=10% align="center"><%=AddUtil.ChangeDate2(auction.getActn_cnt())%></td>
                            </tr>
<%	} %>                            
                        </table>
                    </td>
	            </tr>
            </table>
        </td>
    </tr>
</table>
<br><br>
<table border=0 cellspacing=0 cellpadding=0 width="660">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=660> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width=25% class='title'>�������</td>
                                <td width=25%>
                                	<input type="text" class="text" id="actn_dt" name="actn_dt" placeholder="ex) 20170202" maxlength="8">
                                </td>
                                <td width=25% class='title'>���ȸ��</td>
                                <td width=25%>
                                	<input type="text" class="text" id="actn_cnt" name="actn_cnt" placeholder="���ڸ� �Է�">
                                </td>
                            </tr>
                        </table>
                    </td>
	            </tr>
	        </table>
		</td>
	</tr>	          
</table>
<div style="margin-top: 5px;"><small>�� �� �������� �������, ���ȸ���� �ϰ� ��� �� �����˴ϴ�. �ٽ� �ѹ� Ȯ���ϼ���.</small></div>
<div align="right" style="margin-top: 10px; margin-right: 20px;">
	<input type="button" class="button" value="�������,ȸ�� �ϰ�����" onclick="javascript:updAuctDtCnt();">
</div>
</form>
</body>
</html>