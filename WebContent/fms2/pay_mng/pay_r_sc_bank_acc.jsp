<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	
	Vector vt =  pm_db.getPayRCheckList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
						
		if(confirm('처리하시겠습니까?')){
			fm.action = 'pay_r_sc_bank_acc_a.jsp';
			//fm.target = 'i_no';
			fm.submit();		
		}
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
<% int col_cnt = 12;%>
<table border="0" cellspacing="0" cellpadding="0" width='1370'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">출금송금결과 리스트 (<%=st_dt%>~<%=end_dt%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='1370'>
                <tr> 
                    <td width='70' class='title'>처리일</td>
                    <td width='60' class='title'>처리시간</td>
                    <td width='120' class='title'>출금계좌</td>
                    <td width='100' class='title'>입금은행</td>
                    <td width='100' class='title'>구분</td>        	    
                    <td width='120' class='title'>입금계좌</td>        	                        
        	    <td width="130" class='title'>고객관리성명</td>
                    <td width='130' class='title'>수취인성명</td>
                    <td width='80' class='title'>정상입금액</td>
        	    <td width='130' class='title'>출금통장표시</td>
        	    <td width='130' class='title'>출금항목</td>
        	    <td width='200' class='title'>적요</td>
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    		<input type='hidden' name="actseq" 	value="<%=ht.get("ACTSEQ")%>">
                <tr>                     
                    <td align='center'><%=ht.get("TR_DATE")%></td>                    
                    <td align='center'><%=ht.get("TR_TIME")%></td>
                    <td align='center'>&nbsp;<%=ht.get("TRAN_JI_ACCT_NB")%></td>        	            	    
                    <td align='center'><%=ht.get("BANK_NM")%></span></td>
                    <td align='center'>&nbsp;
                        <select name='conf_st' class='default'>
                            <option value="" >선택</option>
                            <option value="1" <%if(String.valueOf(ht.get("CONF_ST")).equals("1"))%>selected<%%>>확인</option>
                            <option value="2" <%if(String.valueOf(ht.get("CONF_ST")).equals("2"))%>selected<%%>>상시</option>
                            <option value="0" <%if(String.valueOf(ht.get("CONF_ST")).equals("0"))%>selected<%%>>미확인</option>
                        </select></td>        	            	    
                    <td align='center'>&nbsp;<%=ht.get("TRAN_IP_ACCT_NB")%></td>        	            	    
                    <td align='center'><%=ht.get("TRAN_MEMO")%></td>
                    <td align='center'><%=ht.get("TRAN_REMITTEE_NM")%></td>
        	    <td align='right'><%=ht.get("TRAN_AMT")%></td>				
        	    <td align='center'><%=ht.get("TRAN_JI_NAEYONG")%></td>	        		           		    
        	    <td align='center'><%=ht.get("GUBUN_NM")%></td>				
        	    <td align='center'><%=ht.get("P_CONT")%></td>	        		           		    
                </tr>
<%		}	%>
    <tr>
	<td colspan='12' class=h></td>
    </tr>     
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	<td colspan='12'  align='center'>
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
</body>
</html>

