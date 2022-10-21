<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String pay_gubun_nm	= request.getParameter("pay_gubun_nm")	==null?"":request.getParameter("pay_gubun_nm");
	String pay_gubun 	= request.getParameter("pay_gubun")	==null?"":request.getParameter("pay_gubun");
	String pay_est_dt	= request.getParameter("pay_est_dt")	==null?AddUtil.getDate():request.getParameter("pay_est_dt");
	String pay_est_dt2	= request.getParameter("pay_est_dt2")	==null?AddUtil.getDate():request.getParameter("pay_est_dt2");
	String pay_off		= request.getParameter("pay_off")	==null?"":request.getParameter("pay_off");
	
	//조건검색
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String st_dt 		= request.getParameter("st_dt")		==null?pay_est_dt:request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?pay_est_dt2:request.getParameter("end_dt");
	String yet_again 	= request.getParameter("yet_again")	==null?"N":request.getParameter("yet_again");
	
	
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();		
	
	Vector vt = new Vector();
	
	if(pay_gubun.equals("04")) 	vt = ps_db.getPayEstAmt04ListStat(s_kd, t_wd, st_dt, pay_off, yet_again);
	
	int vt_size = vt.size();
	
	long t_amt = 0;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		fm.action = 'pay_list_search_stat.jsp';
		fm.target = '_self';
		fm.submit();		
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function setSearch(est_dt, off_nm, cnt){
	
		var fm = opener.document.form1;		
		
		fm.pay_est_dt.value = est_dt;
		fm.pay_off.value = off_nm;
		
		if(cnt > 200){
			alert('200건이 넘습니다. 200건 작업후 나머지 조회 등록하세요.');
		}
		
		opener.search();
		
		
	}

//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='pay_gubun' value='<%=pay_gubun%>'>
<input type='hidden' name='pay_gubun_nm' value='<%=pay_gubun_nm%>'>
<input type='hidden' name='mode' value=''>

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 출금원장등록 > <span class=style5><%=pay_gubun_nm%> 조회</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=20%>예정일자</td>
                    <td width=30%>&nbsp;
            		    <input type='text' size='11' name='pay_est_dt' class='text' value='<%=pay_est_dt%>'>
						<%if(pay_gubun.equals("55")){%>
						~
						<input type='text' size='11' name='pay_est_dt2' class='text' value='<%=pay_est_dt2%>'>
						<%}%>
        		    </td>
                    <td class=title width=20%>지출처</td>
                    <td width=30%>&nbsp;
            		    <input type='text' size='20' name='pay_off' class='text' value='<%=pay_off%>'>
        		    </td>
        	</tr>
        	<tr>	    
                    <td class=title width=20%>검색조건</td>
                    <td colspan='3'>&nbsp;					
            	      <select name='s_kd'>
			  <%if(pay_gubun.equals("01")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
			  <%}else if(pay_gubun.equals("02")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>						  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>영업사원 </option>
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
			  <%}else if(pay_gubun.equals("03")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>보험사 </option>						  
			  <%}else if(pay_gubun.equals("04")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>금융사 </option>						  
			  <%}else if(pay_gubun.equals("05")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>금융사 </option>						  
			  <%}else if(pay_gubun.equals("11")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>						  
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
                          <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>차대번호 </option>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>정비업체 </option>						  
			  <%}else if(pay_gubun.equals("12")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>탁송업체 </option>
			  <%}else if(pay_gubun.equals("13")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>용품업체 </option>
			  <%}else if(pay_gubun.equals("17")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>검사업체 </option>
			  <%}else if(pay_gubun.equals("14")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>정비업체 </option>
			  <%}else if(pay_gubun.equals("15")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
			  <%}else if(pay_gubun.equals("16")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
			  <%}else if(pay_gubun.equals("21")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>						  
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  						  
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>고지서번호 </option>						  
                          <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>청구기관 </option>						  						  
			  <%}else if(pay_gubun.equals("22")){%>				  
			  <%}else if(pay_gubun.equals("23")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>		
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>지역 </option>						  
			  <%}else if(pay_gubun.equals("24")){%>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>지역 </option>						  
			  <%}else if(pay_gubun.equals("25")){%>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>지역 </option>						  
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  
			  <%}else if(pay_gubun.equals("31")||pay_gubun.equals("37")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>						  
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  
			  <%}else if(pay_gubun.equals("33")||pay_gubun.equals("34")||pay_gubun.equals("35")){%>
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>						  
			  <%}else if(pay_gubun.equals("51")||pay_gubun.equals("52")||pay_gubun.equals("53")||pay_gubun.equals("55")){%>
			  <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>구분 </option>
			  <%}else if(pay_gubun.equals("41")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>사용자 </option>						  			  
			  <%}%>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>		  		  
                </tr>	  
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td align="center"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>			
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
        <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
		<tr>			
		    <td width=10% class='title'>연번</td>
		    <td width=15% class='title'>예정일자</td>			
		    <td width=40% class='title'>지출처</td>
		    <td width=15% class='title'>건수</td>
		    <td width=20% class='title'>금액</td>
		</tr>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
		%>
					  
		<tr>			
		
		    <td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("EST_DT")%></td>
		    <td align='center'><a href="javascript:setSearch('<%=ht.get("EST_DT")%>', '<%=ht.get("OFF_NM")%>', <%=ht.get("CNT")%>);"><%=ht.get("OFF_NM")%></a></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
		    <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
		    
		</tr>				
                <%	}%>
            </table>
	</td>
    </tr>  
</table>
</form>
</body>
</html>

