<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	String actseq 	= "";
	String p_pay_dt = "";
	
	int vid_size = vid.length;
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function save()
	{
		var fm = document.form1;
		
		if(confirm('송금하시겠습니까?')){
			fm.action = 'pay_r_cms_rs_a.jsp';
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
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='size' 		value='<%=vid_size%>'>    


<table border="0" cellspacing="0" cellpadding="0" width=900>
    <tr>
        <td><< 송금요청 결과 등록 >></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' rowspan="2" class='title'>연번</td>
        		    <td width="200" rowspan="2" class='title'>지출처</td>					
               		<td width='100' rowspan="2" class='title'>금액</td>					
					<td colspan="3" class='title'>입금정보</td>					
               		<td colspan="2" class='title'>출금정보</td>
        			<td colspan="2" class='title'>송금결과</td>					
       			</tr>
		        <tr>
		          <td width="70" class='title'>은행</td>
	              <td width="100" class='title'>계좌번호</td>
				  <td width="80" class='title'>예금주</td>
	              <td width='70' class='title'>은행</td>
	              <td width='100' class='title'>계좌번호</td>
	              <td width="80" class='title'>일자</td>
	              <td width="70" class='title'>수수료</td>
	          </tr>		
		  <%
				for(int i=0;i < vid_size;i++){
					
					actseq = vid[i];
					//송금원장
					PayMngActBean bean 	= pm_db.getPayAct(actseq);
					
					if(bean.getAct_bit().equals("1")) continue;
		  %>
		        <tr>
        			<td align='center'><%=i+1%><input type='hidden' name='actseq' value='<%=actseq%>'></td>
        		    <td align='center'><span title='<%=bean.getOff_nm()%>'><%=Util.subData(bean.getOff_nm(), 15)%></span></td>
		  			<td align='right'><%=AddUtil.parseDecimalLong(bean.getAmt())%></td>
		  			<td align='center'><span title='<%=bean.getBank_nm()%>'><%=Util.subData(bean.getBank_nm(), 6)%></span></td>
		  			<td align='center'><%=bean.getBank_no()%></td>
		  			<td align='center'><%=bean.getBank_acc_nm()%></td>					
		  			<td align='center'><span title='<%=bean.getA_bank_nm()%>'><%=Util.subData(bean.getA_bank_nm(), 6)%></span></td>
		  			<td align='center'><%=bean.getA_bank_no()%></td>
		  			<td align='center'><input type='text' name='act_dt' size='11' maxlength='15' class='default' value='<%=AddUtil.ChangeDate2(bean.getAct_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>					
        			<td align='center'><input type='text' name='commi' size='6' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(bean.getCommi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
       			    </td>
		        </tr>
		  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(bean.getAmt()));
		 		}%>
		        <tr>
        		    <td colspan="2" class=title>합계</td>
        		    <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
        		    <td colspan="7" class='title'>&nbsp;</td>		
   		        </tr>
		    </table>
	    </td>
    </tr>  		    	
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a><font color=#CCCCCC>&nbsp;(※인쇄TIP : A3, 가로방향)</font>&nbsp;&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
	<tr>
		<td>&nbsp;</td>	
	</tr>	
<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>		
	<%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>	
    <tr>
	    <td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg_sggg.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<%}%>			  
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
