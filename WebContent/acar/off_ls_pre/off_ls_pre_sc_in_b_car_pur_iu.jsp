<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_car_purBean"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gg = request.getParameter("gg")==null?"":request.getParameter("gg");
	detail = olpD.getPre_detail(car_mng_id);
	auction = olaD.getAuctionPur(car_mng_id, olaD.getAuctionPur_maxSeq(car_mng_id));
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function carPurUpd(ioru){
	var fm = document.form1;
	if(fm.emp_nm.value==""){ alert('������� �������ּ���.!'); return; }
	else if(fm.rpt_no.value== ""){ alert('�����ȣ�� Ȯ���� �ּ���!'); return; }
		
	if(ioru=="i"){
		if(!confirm('����Ͻðڽ��ϱ�?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('�����Ͻðڽ��ϱ�?')){ return; }
	}
	
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_car_pur_upd.jsp";
	fm.target = "i_no";	
	fm.submit();
}

function caroff_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') caroff_search(s_kd);
}	
	

//����� �˻��ϱ�
function caroff_search(s_kd){
		var fm = document.form1;

		if(s_kd == 'car_off_nm')	fm.car_off_nm.value = fm.car_off_nm.value;			
	//	if (fm.car_off_nm.value == "" ) { alert('�˻�� �Է��� �ּ���!'); return; }
		window.open("caroffemp_search.jsp?s_kd=emp_nm&t_wd="+fm.car_off_nm.value, "SEARCH_CAROFF", "left=200, top=200, width=750, height=500, scrollbars=yes");
}	
	//��� �˻��ϱ�
function cont_search(){
		var fm = document.form1;
		if(fm.emp_id.value == '') { alert('������� Ȯ���Ͻʽÿ�.'); return; }
		window.open("cont_search.jsp?auth_rw=<%=auth_rw%>&emp_nm="+fm.emp_nm.value, "SEARCH_CONT", "left=50, top=50, width=950, height=650, scrollbars=yes");
}		
	
-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="gg" value="<%=gg%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������</span></td>
          <td align="right"> 
            <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
          <%if(auction.getRpt_no().equals("") ){%>
          <a href='javascript:carPurUpd("i");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg_new.gif align=absmiddle border=0></a>&nbsp; 
          <%}else{%>
    	  <a href='javascript:carPurUpd("i");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg_bg.gif align=absmiddle border=0></a>&nbsp;
          <a href='javascript:carPurUpd("u");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
          <%}%>
          <%}%>
            <a href='javascript:history.go(-1);' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a> 
          </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            
             	<tr> 
                    <td class='title'>�Ͱ���</td>
                    <td > 
                      &nbsp;<input type="text" name="car_off_nm" size="50"  class="text"  value="<%=auction.getCar_off_nm()%>" style='IME-MODE: active' onKeyDown="javasript:caroff_enter('car_off_nm')" >       			      			 
                    <a href="javascript:caroff_search('car_off_nm');" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a><span class="style1">		</span>
                    </td>
                   <td class='title'>������</td>
                   <td> 
                      &nbsp;<input type="text" name="emp_nm" readonly size="50" class="text" value="<%=auction.getEmp_nm()%>">
                       <input type='hidden' name="emp_id"  value="<%=auction.getEmp_id()%>">   
                      </td> 
                </tr>
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="rent_l_cd" size="50" readonly class="text" value="<%=auction.getRent_l_cd()%>">
        			  <input type='hidden' name="rent_mng_id" value=''>
        			  <a href="javascript:cont_search();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search_gy.gif align=absmiddle border=0></a>
        			  </td>
        			<td class='title'>�����ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="rpt_no" readonly size="50" class="text" value="<%=auction.getRpt_no()%>"></td>
                </tr>
                 <tr> 
                    <td class='title'>������ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="car_no" size="50" class="text" value="<%=auction.getCar_no()%>"></td>        			 
        			<td class='title'>�����</td>
                    <td> 
                      &nbsp;<input type="text" name="dlv_dt" size="50" class="text" value="<%=auction.getDlv_dt()%>"></td>
                </tr>
             </table>
        </td>     
    </tr>
    
 
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
