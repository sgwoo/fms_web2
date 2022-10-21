<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "07");	
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String bank_nm = request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	String fund_yn = request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn");
	
	String cmd			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    
     int scd_size= 0; //total
    
     scd_size =FineList.size(); 
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function cal_rest(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.scd_size.value);		
				
		var t4_pay_amt 	= 0;
		var t5_pay_amt 	= 0;
		var s_pay_amt 	= 0;
		var ss_pay_amt 	= 0;


		if ( scd_size < 2  ) {
			t4_pay_amt 	= t4_pay_amt + toInt(parseDigit(fm.amt4.value));		
			t5_pay_amt 	= t5_pay_amt + toInt(parseDigit(fm.amt5.value));		
			fm.s_amt.value = parseDecimal(toInt(parseDigit(fm.amt4.value))+toInt(parseDigit(fm.amt5.value)));
			s_pay_amt 	= s_pay_amt + toInt(parseDigit(fm.s_amt.value));		
					
	//		fm.ss_amt.value = parseDecimal( ( toInt(parseDigit(fm.amt4.value))+toInt(parseDigit(fm.amt5.value))) /2 );
			ss_pay_amt 	= ss_pay_amt + toInt(parseDigit(fm.ss_amt.value));		
			
		} else {
			for(var i = 0 ; i < scd_size ; i ++){
				t4_pay_amt 	= t4_pay_amt + toInt(parseDigit(fm.amt4[i].value));	
				t5_pay_amt 	= t5_pay_amt + toInt(parseDigit(fm.amt5[i].value));		
				fm.s_amt[i].value = parseDecimal(toInt(parseDigit(fm.amt4[i].value))+toInt(parseDigit(fm.amt5[i].value)));	
				s_pay_amt 	= s_pay_amt + toInt(parseDigit(fm.s_amt[i].value));		
	//			fm.ss_amt[i].value =  parseDecimal( ( toInt(parseDigit(fm.amt4[i].value))+toInt(parseDigit(fm.amt5[i].value) ) ) /2 ) ;	
				ss_pay_amt 	= ss_pay_amt + toInt(parseDigit(fm.ss_amt[i].value));		
			}
		}
			
		fm.t4_pay_amt.value = parseDecimal(t4_pay_amt);
		fm.t5_pay_amt.value = parseDecimal(t5_pay_amt);
		fm.s_pay_amt.value = parseDecimal(s_pay_amt);
		fm.ss_pay_amt.value = parseDecimal(ss_pay_amt);
		
	
	}		
		
	function save()
	{
		var fm = document.form1;
		
		if(confirm('변경하시겠습니까?'))
		{		
			fm.target = 'i_no';			
			fm.action = 'bank_doc_list_reg_a.jsp'
			fm.submit();
		}		
		
	}	
	
		//계약검색하기
	function find_cont_search(){
		var fm = document.form1;
		window.open("find_cont_search_re.jsp?cltr_rat=<%=FineDocBn.getCltr_rat()%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&bank_id="+fm.bank_id.value+"&bank_nm="+fm.bank_nm.value+"&doc_id="+fm.doc_id.value+"&fund_yn="+fm.fund_yn.value, "SEARCH_FINE", "left=50, top=50, width=1000, height=700, scrollbars=no");
	}
	
	function bank_doc_list_del(rent_l_cd)
	{
		var fm = document.form1;
		fm.cmd.value = "d";
		fm.rent_l_cd.value = rent_l_cd;
		if(confirm('삭제하시겠습니까?')){	
				fm.action='bank_doc_list_reg_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}
	}	
//-->	
</script>
</head>
<body leftmargin="15" >

<form action="" name="form1" method="POST" >

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='bank_nm' value='<%=bank_nm%>'>
<input type='hidden' name='fund_yn' value='<%=fund_yn%>'>
<input type='hidden' name='scd_size' value='<%=scd_size%>'>
<input type='hidden' name='cltr_rat' value='<%=FineDocBn.getCltr_rat()%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='rent_l_cd' value=''>
  <table width='1220' border="0" cellpadding="0" cellspacing="0">
     <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 구매자금관리 > <span class=style5>대출취급 신청공문관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr>
        <td class=line2></td>
    </tr>
 
	<tr> 
	      <td class="line">
		  <table width="100%" border="0" cellspacing="1" cellpadding="0">
	     
	        <tr align="center">
	          <td height="30" width="3%"  rowspan="2"  class='title' >구분</td>
	          <td height="25" colspan="2"  class='title' >계약사항</td>           
	          <td height="25" colspan="5"  class='title' >자동차사항</td>
	          <td height="25" colspan="4"  class='title' >대출금</td>
	          <td height="25" colspan="1"  class='title' >담보</td>	          
	        </tr>
	        <tr align="center">
	          <td width="8%" height="25" class='title' >상호/성명</td>
	          <td width="6%" height="25" class='title' >계약번호</td>
	          <td width="7%" height="25" class='title' >차종</td>
	          <td width="5%" height="25" class='title' >차량번호</td>
	          <td width="6%" height="25" class='title' >소비자가격</td>
	          <td width="6%" height="25" class='title' >구입가격</td>
	          <td width="6%" height="25" class='title' >출고예정일</td>
	          <td width="6%" height="25" class='title' >원금</td>
	          <td width="4%" height="25" class='title' >취득세</td>
	          <td width="6%" height="25" class='title' >예정액</td>
	          <td width="6%" height="25" class='title' >취급요청일</td>
	          <td width="6%" height="25" class='title' >설정금액</td>	          
	        </tr>	     
	 
 <% if(FineList.size()>0){
			for(int i=0; i<FineList.size(); i++){ 
				Hashtable ht = (Hashtable)FineList.elementAt(i);
			
				for(int j=0; j<1; j++){
					t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))); //대여료
					t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2"))); //총대여료
					t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT3")));	//구매가격
					t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT4")));	//대출금액
					t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));	//차량가격(탁송제외) -소비자가격 
					t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("PRE_AMT")));	//선납금액
					t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));	//취득세
					t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));	//담보설정액
				}			
				
	%>
	     <tr align="center"> 
	    	<input type='hidden' name='seq_no' value='<%=ht.get("SEQ_NO")%>'>
	        <td  width="3%" height="30" ><a href="javascript:bank_doc_list_del('<%=ht.get("RENT_L_CD")%>')">D</a>&nbsp;<%=i+1%></td>
	        <td  width="8%"><%=ht.get("FIRM_NM")%></td>
	        <td  width="6%" ><%=ht.get("RENT_L_CD")%></td>    
	     
	        <td  width="7%" ><%=ht.get("CAR_NM")%></td>
	        <td  width="5%" ><%=ht.get("CAR_NO")%></td>
	        <td  width="6%" align="right"><%=Util.parseDecimal(ht.get("CAR_F_AMT"))%></td>
	        <td  width="6%" align="right"><input type='hidden' name='amt3'  value='<%=Util.parseDecimal(ht.get("AMT3"))%>'><%=Util.parseDecimal(ht.get("AMT3"))%> </td>
	        <td  width="6%" ><%=ht.get("DLV_EST_DT")%></td>
	        <td  width="6%" align="right"><input type='text' name='amt4' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value);  cal_rest();'></td>
	        <td  width="4%" align="right"><input type='text' name='amt5' size='10' class='num'  value='<%=Util.parseDecimal(ht.get("AMT5"))%>' onBlur='javascript:javascript:this.value=parseDecimal(this.value);  cal_rest();'></td>
	        <td  width="6%" align="right"><input type='text' name='s_amt' size='10' class='num' readonly value='<%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) +  AddUtil.parseLong(String.valueOf(ht.get("AMT5"))))%>'></td>
	        <td  width="6%"><%=ht.get("END_DT")%></td>
	        <td  width="6%"align="right" >	        
	        <input type='text' name='ss_amt' size='10' class='num'  value='<%=Util.parseDecimal(String.valueOf(ht.get("AMT6")))%>'></td>
	            
	    </tr>
    <% 	} %>
	    <tr align="center"> 
	        <td colspan=5 height="30" class=title >합계</td>       
	        <td align="right" class=title><%=Util.parseDecimal(t_amt5[0])%></td>
	        <td align="right" class=title><%=Util.parseDecimal(t_amt3[0])%></td>
	        <td class=title></td>
	        <td align="right" class=title><input type='text' name='t4_pay_amt' size='12' class='fixnum' value='<%=Util.parseDecimal(t_amt4[0])%>'></td>
	        <td align="right" class=title><input type='text' name='t5_pay_amt' size='12' class='fixnum' value='<%=Util.parseDecimal(t_amt7[0])%>'></td></td>
	        <td align="right" class=title><input type='text' name='s_pay_amt' size='12' class='fixnum' value='<%=Util.parseDecimal(t_amt4[0]+t_amt7[0])%>'></td>
	        <td class=title></td>
	        <td align="right" class=title><input type='text' name='ss_pay_amt' size='12' class='fixnum' value='<%=Util.parseDecimal(t_amt8[0])%>'></td>
	    
	     </tr>
	    </table>
        </td> 
    </tr>  
	     
<%} %>
    <tr> 
      <td height="5" align="center"></td>
    </tr>	
  	
    <% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("영업수당관리자",user_id) || nm_db.getWorkAuthUser("대출관리자",user_id)  ){%>
	<tr> 
        <td><a href="javascript:find_cont_search();"><img src=../images/center/button_plus.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
		<td align="right">	
		   <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>		
		 <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
		 <% } %>
		  &nbsp;<a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>	  	
		</td>
	</tr>	
	<%}%>
  </table>
 
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
