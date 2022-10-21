<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	
	
	String bank_no 	= request.getParameter("bank_no")==null? "":request.getParameter("bank_no");
	String actseq 	= request.getParameter("actseq")==null? "":request.getParameter("actseq");
	
	//송금원장
	PayMngActBean act 	= pm_db.getPayAct(actseq);
	

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function save()
	{
		var fm = document.form1;
						
		if(confirm('처리하시겠습니까?')){
			fm.action = 'pay_r_bank_acc_st_a.jsp';
			fm.target = 'i_no';
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
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 	value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name="actseq" 	value="<%=actseq%>">  
  



<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><< 입금계좌 확인현황 >></td>
    </tr>  
    <tr>
	<td class=h></td>
    </tr>     
    <tr>
        <td class=line2></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title>지출처</td>
                    <td>&nbsp;<%=act.getOff_nm()%></td>
                </tr>		                          	
                <tr>
                    <td width="20%" class=title>은행명</td>
                    <td>&nbsp;<%=act.getBank_nm()%></td>
                </tr>	
                <tr>
                    <td class=title>계좌번호</td>
                    <td>&nbsp;<%=bank_no%></td>
                </tr>                
                <tr>
                    <td class=title>예금주</td>
                    <td>&nbsp;<%=act.getBank_acc_nm()%></td>
                </tr>		
                <tr>
                    <td class=title>확인구분</td>
                    <td>&nbsp;<input type='radio' name="conf_st" value='1'>확인
			      <input type='radio' name="conf_st" value='2'>상시
			      <input type='radio' name="conf_st" value='0'>미확인
                    
                    </td>
                </tr>		
	    </table>
	</td>
    </tr> 	
    <tr>
	<td class=h></td>
    </tr>   
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	  
    <tr>
	<td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	</td>
    </tr>	
    <%}%>
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
