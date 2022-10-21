<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.* "%>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");


	String st_dt 	= request.getParameter("st_dt")	 ==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt") ==null?"":request.getParameter("end_dt");
	String s_cnt 	= request.getParameter("s_cnt")  ==null?"":request.getParameter("s_cnt");
	
	
	//마감변수
	String var1 = at_db.getAcctVarCase("acct_var1");
	String var2 = at_db.getAcctVarCase("acct_var2");
	String var3 = at_db.getAcctVarCase("acct_var3");

	
	
	
	Vector vt = new Vector();
	int vt_size = 0;
		
		
	if(st_dt.equals("") && end_dt.equals("") && s_cnt.equals("")){	
		st_dt 	= var1;
		end_dt 	= var2;
		s_cnt 	= var3;			
	}else{
		vt = at_db.getRm1C1List(st_dt, end_dt, s_cnt);
		vt_size = vt.size();
	}
	
	int exception_cnt = 0;


%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function Search()
	{
		var fm = document.form1;
		if(fm.st_dt.value == '')	{ alert('시작일을 입력하십시오.'); 	fm.st_dt.focus(); 	return; }	
		if(fm.end_dt.value == '')	{ alert('종료일을 입력하십시오.'); 	fm.end_dt.focus(); 	return; }
		if(fm.s_cnt.value == '')	{ alert('샘플수를 입력하십시오.'); 	fm.s_cnt.focus(); 	return; }
		fm.target = "_self";
		fm.action = "rm1_c1.jsp";	
		fm.submit();
	}
	
	//프린트하기
	function Print()
	{
		var fm = document.form1;
		if(<%=vt_size%> == 0)		{ alert('검색데이타가 없습니다. 먼저 검색하여 주십시오.'); 	fm.st_dt.focus(); 	return; }	
		fm.target = "_blank";
		fm.action = "rm1_c1_print.jsp";	
		fm.submit();
	}	
	
	//당일마감하기
	function save()
	{
		var fm = document.form1;
		var size = toInt(fm.size.value);
		var reg_chk = 0;
		/*
		for(i=0; i<size; i++){
			if(size == 1){
				if(fm.result.value=='') reg_chk++;
			}else{
				if(fm.result[i].value=='') reg_chk++;
			}
		}				
		if(reg_chk >0){ alert('평가를 하십시오.'); return; }
		*/
		
		
		if(confirm('마감 하시겠습니까?')){
			fm.target = "i_no";	
			fm.action = "/acct/rc/stat_acct_a.jsp";	
			fm.submit();
		}
	}	
	
	//평가일괄표시
	/*
	function cng_display(idx){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		for(i=0; i<size; i++){
			if(size == 1){
				fm.result.options[idx].selected = true;
			}else{
				fm.result[i].options[idx].selected = true;
			}
		}
	}
	*/	
	
	//초기화면가기
	function f_init()
	{
		var fm = document.form1;
		fm.st_dt.value = '';
		fm.end_dt.value = '';
		fm.s_cnt.value = '';
		fm.target = "_self";
		fm.action = "rm1_c1.jsp";	
		fm.submit();
	}	
//-->
</script>
</head>

<body leftmargin="15" onload="javascript:document.form1.st_dt.focus();">
<form name="form1" method="post" action="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='size' 	value='<%=vt_size%>'>
  <input type='hidden' name='acct_st' 	value='rm1_c1'>
  <input type='hidden' name='value_size' value='6'>
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>내부통제 > 대여차량관리Cycle > <span class=style5>차량대금지급요청승인</span></span></td>
            <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td>
        <table border=0 cellspacing=1>
          <tr> 
            <td>
              <!--기준기간-->
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/arrow_gjij.gif align=absmiddle>
	      <input type='text' size='12' name='st_dt' class='text' value='<%=AddUtil.ChangeDate2(st_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
              ~ 
              <input type='text' size='12' name='end_dt' class='text' value='<%=AddUtil.ChangeDate2(end_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
              <!--샘플수-->
              &nbsp;&nbsp;&nbsp;&nbsp;
              <img src=/acct/images/center/arrow_nsp.gif align=absmiddle> 
              <input type='text' size='3' name='s_cnt' class='text' value="<%=s_cnt%>">개
              <!--검색버튼-->
              &nbsp;&nbsp;&nbsp;&nbsp;
              <a href="javascript:Search();"><img src=/acct/images/center/button_search.gif align=absmiddle border=0></a>
              <!--출력버튼-->
              <%if(vt_size>0){%>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <a href="javascript:Print();"><img src=/acct/images/center/button_print.gif align=absmiddle border=0></a>
              <%}%>
	    </td>
          </tr>
        </table>
      </td>
    </tr>  
    <tr>
      <td class=h></td>
    </tr>      
    <!--
    <tr>
      <td align="right">
      	<input type="radio" name="all_r" value="Y" onClick="javascript:cng_display(1)">적합
	<input type="radio" name="all_r" value="N" onClick="javascript:cng_display(2)">부적합
      </td>
    </tr>      
    -->
    <tr>
      <td class=line2></td>
    </tr>  
    <tr>
      <td class='line'>
	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	  <tr>
	    <td class="title" width="5%">No.</td>
	    <td class="title" width="10%">계약번호</td>
	    <td class="title" width="20%">계약자</td>
	    <td class="title" width="15%">차명</td>	
	    <td class="title" width="10%">출고일자</td>    
	    <td class="title" width="10%">승인자</td>
	    <td class="title" width="10%">승인일자</td>	    	    
	    <!--<td class="title" width="10%">평가</td>-->
	  </tr>
	  <%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);	
			
			if(String.valueOf(ht.get("USER_NM5")).equals("")){
			//	exception_cnt++;
			}
			
			%>
          <input type='hidden' name="seq" 	value="<%=i+1%>">
	  <input type='hidden' name="value1" 	value="<%=ht.get("RENT_L_CD")%>">
	  <input type='hidden' name="value2" 	value="<%=ht.get("FIRM_NM")%>">
	  <input type='hidden' name="value3" 	value="<%=ht.get("CAR_NM")%>">
	  <input type='hidden' name="value4" 	value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%>">
	  <input type='hidden' name="value5" 	value="<%=ht.get("USER_NM5")%>">
	  <input type='hidden' name="value6" 	value="<%=ht.get("USER_DT5")%>">
	  <input type='hidden' name="value7" 	value="">			
	  <input type='hidden' name="value8" 	value="">
	  <input type='hidden' name="value9" 	value="">
	  <input type='hidden' name="value10" 	value="">
	  <input type='hidden' name="value11" 	value="">
	  <input type='hidden' name="value12" 	value="">
	  <input type='hidden' name="value13" 	value="">
	  <input type='hidden' name="value14" 	value="">
	  <input type='hidden' name="value15" 	value="">
	  <input type='hidden' name="value16" 	value="">
	  <input type='hidden' name="value17" 	value="">			
	  <input type='hidden' name="value18" 	value="">
	  <input type='hidden' name="value19" 	value="">
	  <input type='hidden' name="value20" 	value="">
	  <input type='hidden' name="result" 	value="">
	  <tr>
	    <td align="center"><%=i+1%></td>
	    <td align='center'><%=ht.get("RENT_L_CD")%></td>            
            <td align='center'><%=ht.get("FIRM_NM")%></td>	    
            <td align='center'><%=ht.get("CAR_NM")%></td>     
            <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>     
            <td align='center'><%=ht.get("USER_NM5")%></td>            
            <td align='center'><%=ht.get("USER_DT5")%></td>            
	      <!--
	    <td align='center'>
	      <select name="result">
	        <option value="">선택</option>
                <option value="Y">적합</option>
                <option value="N">부적합</option>
              </select>
            </td>
              -->
	  </tr>
	  <%	}%>
	</table>
      </td>
    </tr>
    <tr>
      <td class=h ></td>
    </tr>
    <%if(vt_size>0){%>
    <tr>
      <td class='line'>
	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	  <tr>
	    <td>Test 결과 (예외사항 수 <input type='text' size='3' name='exception_cnt' class='whitetext' value="<%//=exception_cnt%>"> / 샘플 수 <%=vt_size%>)</td>
	  </tr>
	</table>
      </td>
    </tr>
    <tr>
      <td class=h ></td>
    </tr>    
    <tr>
      <td align="right">
        <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acct/images/center/button_mg.gif border=0 align=absmiddle></a>        
      </td>
    <tr> 
    <%}else{%>	    
    <tr>
      <td>* 기간, 샘플수를 입력하고 검색하십시오.</td>
    </tr>    
    <%}%>
    <tr>
      <td>&nbsp;</td>
    </tr> 
    <tr>
      <td class=line2></td>
    </tr>  
    <tr>
      <td class='line'>
	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	  <tr>
	    <td class="title" width="15%">서브프로세스명</td>
	    <td width="85%">&nbsp;
	      대여차량취득의사결정 및 취득</td>	    
	  </tr>     
	  <tr>
	    <td class="title">통제활동번호/명</td>
	    <td>&nbsp;
	      C1/차량대금지급요청에 대한 승인 </td> 
	  </tr>     
	  <tr>
	    <td class="title">테스트 절차</td>
	    <td>&nbsp;
	      자산 구매 건을 선택한 후 FMS상 총무팀장의 승인이 있는지 확인한다.
	    </td>	    
	  </tr>     
	</table>
      </td>
    </tr>	     
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

