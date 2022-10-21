<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pay_action(){
		var fm = document.form1;
		
		if(fm.com_tint_coupon_pay_dt.value == ''){ alert('쿠폰지급일를 입력하십시오.'); return; }
		
		if(confirm('등록하시겠습니까?')){	
		
			fm.action='pur_coupon_pay_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">


<table border="0" cellspacing="0" cellpadding="0" width=810>
    <tr>
        <td><< 일괄지급처리 >></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' class='title'>연번</td>
        		    <td width='120' class='title'>계출번호</td>
        		    <td width="150" class='title'>차대번호</td>
        		    <td width="160" class='title'>출고영업소</td>					
               		<td width='120' class='title'>쿠폰구분</td>					
               		<td width='100' class='title'>쿠폰수령일</td>
               		<td width='130' class='title'>협력업체</td>
       			</tr>		
		  <%
				String vid[] = request.getParameterValues("ch_cd");
				String rent_l_cd = "";
				int vt_size = vid.length;
				for(int i=0;i < vt_size;i++){
					rent_l_cd = vid[i];
					Hashtable ht = a_db.getCarPurCouPonCase(rent_l_cd);
		  %>
		        <tr>
        			<td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("RPT_NO")%>
						<input type='hidden' name='rent_mng_id' value='<%=ht.get("RENT_MNG_ID")%>'>
						<input type='hidden' name='rent_l_cd' value='<%=ht.get("RENT_L_CD")%>'>
					</td>
        		    <td align='center'><%=ht.get("CAR_NUM")%></td>
        		    <td align='center'><%=ht.get("CAR_OFF_NM")%></td>					
               		<td align='center'><%=ht.get("COM_COUPON_NM")%></td>					
               		<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("COM_TINT_COUPON_DT")))%></td>
               		<td align='center'><%=ht.get("OFF_NM")%></td>
       			</tr>
				<%}%>
		    </table>
	    </td>
    </tr>  		    	
	<tr>
	    <td class=h></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>  		
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='810'>
		        <tr>
        			<td width='150' class='title'>쿠폰지급일</td>
        		    <td>&nbsp;<input type='text' size='15' name='com_tint_coupon_pay_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
       			</tr>		
		    </table>
	    </td>
    </tr>  		    	
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
		<td align="right">
		  <a href="javascript:pay_action()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
