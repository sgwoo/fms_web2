<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_tot_amt = request.getParameter("rent_tot_amt")==null?"":request.getParameter("rent_tot_amt");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "02");
	
	Vector conts = rs_db.getScdRentList(s_cd, "");
	int cont_size = conts.size();
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//잔액셋팅
	function set_rest_amt(){
		var fm = document.form1;
		
		
		return;
		for(i=0;i<parseInt(fm.c_size.value);i++){	
			if(i == 0){
				if(fm.c_size.value == '0'){
					fm.rest_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.rent_amt.value)) ) ;
			 	}else{
					fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.rent_amt[i].value)) ) ;
			 	}			 
			}else{
				if(fm.c_size.value == '0'){
					fm.rest_amt.value = parseDecimal(toInt(parseDigit(fm.rest_amt.value)) - toInt(parseDigit(fm.pay_amt.value)) ) ;		
			 	}else{
					fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.rest_amt[i-1].value)) - toInt(parseDigit(fm.pay_amt[i].value)) ) ;		
			 	}			 
			}
		}		
	}
	
	function set_rent_amt(idx){
		var fm = document.form1;
		if(<%=cont_size%>==0){
			fm.rent_amt.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) + toInt(parseDigit(fm.rent_v_amt.value)));
		}else{
			fm.rent_amt[idx].value = parseDecimal(toInt(parseDigit(fm.rent_s_amt[idx].value)) + toInt(parseDigit(fm.rent_v_amt[idx].value)));
		}
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post' target=''>
<input type='hidden' name='c_size' value='<%=cont_size%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='rent_tot_amt' value='<%=rent_tot_amt%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='9%' class='title'>요금구분</td>
                    <td width='3%' class='title'>연장</td>
                    <td width='9%' class='title'>수금구분</td>
                    <td width='8%' class='title'>입금예정일</td>
                    <td width='8%' class='title'>공급가</td>		
                    <td width='7%' class='title'>부가세</td>		
                    <td width='8%' class='title'>합계</td>
                    <td width='8%' class='title'>입금일자 </td>
                    <td width='8%' class='title'>실입금액</td>                    
                    <td width='7%' class='title'>세금계산서</td>						
                    <td width='4%' class='title'>연체일</td>
                    <td width='4%' class='title'>연체료</td>
                    <td width='5%' class='title'>입금<br>취소</td>
                    <td width='9%' class='title'>수정<br>삭제</td>
                </tr>
		<%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
			
				Hashtable sr = (Hashtable)conts.elementAt(i);
				
				String is = "";
				String white = "";
				
				if(!String.valueOf(sr.get("PAY_DT")).equals("") || String.valueOf(sr.get("RENT_AMT")).equals("0")){
					is 	= "class='is'";
					white 	= "white";
				}
				
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(sr.get("RENT_S_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(sr.get("RENT_V_AMT")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(sr.get("RENT_AMT")));
				%>					
    			<input type='hidden' name='tm' value='<%=sr.get("TM")%>'>
    			<input type='hidden' name='rest_amt' value='<%=sr.get("REST_AMT")%>'>
                <tr> 
                    <td <%=is%> align='center'><%=i+1%></td>
                    <td <%=is%> align='center'>
                                <select name="rent_st">
            	              	  <option value="">==선택==</option>			              	              	  
                	          <option value="1" <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>selected<%}%>>예약금</option>
                    	          <option value="2" <%if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>selected<%}%>>선수대여료</option>
                    	          <option value="3" <%if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>selected<%}%>>대여료</option>
                    	          <option value="5" <%if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>selected<%}%>>연장대여료</option>
                    	          <option value="4" <%if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>selected<%}%>>정산금</option>
                    	          <option value="6" <%if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>selected<%}%>>보증금</option>
                    	          <option value="7" <%if(String.valueOf(sr.get("RENT_ST")).equals("7")){%>selected<%}%>>연체이자</option>
                    	          <option value="8" <%if(String.valueOf(sr.get("RENT_ST")).equals("8")){%>selected<%}%>>과태료</option>
        	                </select>        	                
        	    </td>
        	    <td <%=is%> align='center'>
        	    		<input type='text' name='ext_seq' size='2' value='<%=sr.get("EXT_SEQ")%>' class='<%=white%>text'>
        	    </td>
        	    <td <%=is%> align='center'>
        	                <select name="paid_st">
            	                  <option value="">=선택=</option>			  
                	          <option value="1" <%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>selected<%}%>>현금</option>
                    	          <option value="2" <%if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>selected<%}%>>신용카드</option> 
                    	          <option value="3" <%if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>selected<%}%>>자동이체</option>					  
                    	          <option value="4" <%if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>selected<%}%>>무통장입금</option>					  					  
        	                </select>        					
        			</td>		
                    <td <%=is%> align='center'><input type='text' name='est_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(sr.get("EST_DT")))%>' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td <%=is%> align='center'><input type='text' name='rent_s_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_S_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>			
                    <td <%=is%> align='center'><input type='text' name='rent_v_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_V_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>			
                    <td <%=is%> align='center'><input type='text' name='rent_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>
                    <td <%=is%> align='center'><input type='text' name='pay_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td <%=is%> align='center'><input type='text' name='pay_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rest_amt()'></td>                    
                    <td <%=is%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(sr.get("TAX_DT")))%>
                      <!--세금계산서 발행요청-->
                      <%if(String.valueOf(sr.get("TAX_DT")).equals("") && AddUtil.parseLong(String.valueOf(sr.get("RENT_V_AMT"))) >0 && !String.valueOf(sr.get("PAID_ST")).equals("2")){%>
                      발행요청
                      <%}%>
                    </td>
                    <td <%=is%> align='right'><%=sr.get("DLY_DAYS")%></td>
                    <td <%=is%> align='right'><%=Util.parseDecimal(String.valueOf(sr.get("DLY_AMT")))%></td>
                    <td <%=is%> align='center'>
                      <!--입금/취소-->
                      <%if(!mode.equals("view")){%>
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){
        			  			if(String.valueOf(sr.get("PAY_DT")).equals("")){%>
        	              <a href="javascript:parent.change_scd('p', <%=i%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_ig.gif  align=absmiddle border="0"></a>
        				  <%	}else{%>
        	              <a href="javascript:parent.change_scd('c', <%=i%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_cancel.gif  align=absmiddle border="0"></a>			  
        				  <%	}%>				  
                      <%	}%>
                      <%}%>
        			</td>
                    <td <%=is%> align='center' width='9%'>
                      <!--수정/삭제-->
                      <%if(!mode.equals("view")){%>
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:parent.change_scd('u', <%=i%>)" onMouseOver="window.status=''; return true" title='수정'><img src=/acar/images/center/button_in_modify.gif  align=absmiddle border="0"></a>
                      <%	}%>	
        			 
        			  <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//수정,삭제%>					
        				<a href="javascript:parent.change_scd('d', <%=i%>)" onMouseOver="window.status=''; return true" title='삭제'><img src=/acar/images/center/button_in_delete.gif  align=absmiddle border="0"></a>
        			  <%	}%>
        		 <%}%>	  
                    </td>
                </tr>	  
<%		}%>
                <tr> 
                    <td class="title" colspan='5'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%>원&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>원&nbsp;</td>
        	    <td class="title" colspan='7'>&nbsp;</td>
                </tr>
<%	}%>
<%if(!mode.equals("view")){%>
<!--추가-->
			        <input type='hidden' name='tm' value=''>	
			        <input type='hidden' name='rest_amt' value=''>		
                <tr> 
                    <td align='center'>-</td>
                    <td align='center'>
        			<select name="rent_st">
            	              	  <option value="">==선택==</option>			  
                	          <option value="1">예약금</option>
                    	          <option value="2">선수대여료</option>
                    	          <option value="3">대여료</option>
                    	          <option value="5">연장대여료</option>
                    	          <option value="4">정산금</option>
                    	          <option value="6">보증금</option>
                    	          <option value="7">연체이자</option>
                    	           <option value="8">과태료</option>
        	                </select>
        			</td>
        	    <td align='center'>
        	    		<input type='text' name='ext_seq' size='2' value='' class='text'>
        	    </td>		
        	    <td align='center'>
        			<select name="paid_st">
                	          <option value="1">현금</option>
                    <!--	          <option value="2">신용카드</option> -->
                    	          <option value="3">자동이체</option>					  
                    	          <option value="4">무통장입금</option>					  					  
        	                </select>
        			</td>		
                    <td align='center'><input type='text' name='est_dt' size='11' value='' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='center'><input type='text' name='rent_s_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_rent_amt(<%=cont_size%>);'></td>			
                    <td align='center'><input type='text' name='rent_v_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=cont_size%>);'></td>			
                    <td align='center'><input type='text' name='rent_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=cont_size%>);'></td>
                    <td align='center'><input type='text' name='pay_dt' size='11' value='' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='center'><input type='text' name='pay_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rest_amt();'></td>                    
                    <td align='right'>-&nbsp;</td>
                    <td align='right'>-&nbsp;</td>					
                    <td align='right'>-&nbsp;</td>
                    <td align='center'>
                      <%//	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        	              <a href="javascript:parent.change_scd('a', <%=cont_size%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_plus.gif  align=absmiddle border="0"></a>
        			  <%//	}%>				  
        			</td>
                    <td align='center'>-</td>
                </tr>	
<%}%>                  
            </table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
//	set_rest_amt()
//-->
</script>
</body>
</html>