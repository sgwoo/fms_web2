<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector vt = new Vector();
	if(!t_wd.equals("")){
		vt = a_db.getContList_20160614(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);
	}
	int vt_size = vt.size(); 
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//계약선택시 부모창에 계약 세팅
	function set_cont(rent_l_cd, rent_mng_id){
		var fm = document.form1;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.rent_mng_id.value 	= rent_mng_id;
		
		fm.action = 'ecar_charg_pop.jsp';
		fm.target = 'charg_pop';
		
		fm.submit();
		self.close();
	}
	
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post'>
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="rent_mng_id" value="">
<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">영업관리 > 계출관리 > 전기차 충전기 신청 ></span><span class="style5"> 계약 검색 </span>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 20px;">
    <tr> 
  		<td><label><i class="fa fa-check-circle"></i> 계약 검색 </label>&nbsp;		
    		<select name='s_kd' class='select'>
      			<option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
				<option value='3' <%if(s_kd.equals("3"))%>selected<%%>>차량번호</option>
			</select>
			<input type="text" name="t_wd" value="<%=t_wd%>" size="25" class='text input' onKeyDown="javasript:enter()" style='IME-MODE: active'>
			<button class='button' onclick='javascript:search();'>검색</button>		
      	</td>
    </tr>
    <tr> 
      	<td>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
      	<td class=line> 
        	<table border="0" cellspacing="1" width=100%>
        		<colgroup>
	        		<col width='5%'>
	        		<col width='6%'>
	        		<col width='16%'>
	        		<col width='12%'>
	        		<col width='18%'>
	        		<col width='*'>
	        		<col width='10%'>
        		</colgroup>
          		<tr>
		            <td class=title>연번</td>
		            <td class=title>구분</td>
		            <td class=title>계약번호</td>
		            <td class=title>계약일<br>(승계일)</td>
		            <td class=title>고객</td>
		            <td class=title>차종</td>
		            <td class=title>차량번호</td>
          		</tr>
          	<%if(vt_size > 0){ 
          			for(int i=0; i<vt_size; i++){
          				Hashtable ht = (Hashtable)vt.elementAt(i);
          	%>
          		<tr>
          			<td align="center"><%=i+1%></td>
          			<td align="center">
          				<%if(String.valueOf(ht.get("USE_YN")).equals("")){%>
                              <%if(String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%><font color=red><%}else{%><font color=#000000><%}%>
                              <%=ht.get("SANCTION_ST")%></font>
                        <%}else if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>진행<%}else if(String.valueOf(ht.get("USE_YN")).equals("N")){%>해지<%}%>
          			</td>
          			<td align="center">
          				<a href="javascript:set_cont('<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_MNG_ID")%>');"><%=ht.get("RENT_L_CD")%></a>
          			</td>
          			<td align="center">
          				<%if(s_kd.equals("21")){%>
	                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
	                    <%}else{%>
	                        <%if(String.valueOf(ht.get("CNG_ST")).equals("계약승계") && String.valueOf(ht.get("EXT_ST2")).equals("")){%>
	                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
	                        <%}else{%>
	                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
	                        <%}%>                        
	                    <%}%>
          			</td>
          			<td align="center"><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></td>
          			<td align="center"><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></td>
          			<td align="center"><%=ht.get("CAR_NO")%></td>
          		</tr>
       		<% 	}%>	
          	<%}else{ %>
          		<tr><td colspan="7" align="center">검색데이터가 없습니다.</td></tr>
          	<%} %>
        	</table>
      	</td>
	</tr>
   	<tr> 
      	<td>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>