<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.res_search.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	
	AddForfeitDatabase cdb = AddForfeitDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if(!car_no.equals("") && !vio_dt.equals("")){
		vt = cdb.getFineSearchContList(car_no, vio_dt);
	}
	int cont_size = vt.size();
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_ts.css">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
	
	function SetCarRent(car_st, car_mng_id,rent_mng_id,rent_l_cd, rent_st, car_no, mng_id) {
		window.opener.getContInfo(car_st, car_mng_id,rent_mng_id,rent_l_cd, rent_st, car_no, mng_id);
		self.close();	
	}
	
	function search_cont() {
		var fm = document.form1;
		
		if(fm.car_no.value == '' || fm.car_no.value.length < 7){ alert('정확한 차량번호를 입력하십시오'); return;} 
		if(fm.vio_dt.value == '' || fm.vio_dt.value.length < 8){ alert('정확한 위반일자를 입력하십시오'); return;} 
		
		fm.target = 'FineSearchCont';	
		fm.action = 'fine_search_cont.jsp';
		fm.submit();	
	}

	
	function SearchFocus(arg){
		var fm = document.form1;		
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(arg=="car_no"){
				fm.vio_dt.focus();
			}else if(arg=="vio_dt"){
				search_cont();
			}
		}
	}
	
	function view_scont(rent_mng_id, rent_l_cd, car_mng_id){
		var SUBWIN="/fms2/lc_rent/view_res.jsp?c_id="+car_mng_id;	
		window.open(SUBWIN, "VIEW_RES", "left=50, top=50, width=1050, height=600, scrollbars=yes, status=yes");
	}
	function view_cons(rent_mng_id, rent_l_cd, car_mng_id){
		var fm = document.form1;	
		var SUBWIN="/acar/fine_mng/view_cons.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id+"&vio_dt="+fm.vio_dt.value;	
		window.open(SUBWIN, "VIEW_CONS", "left=50, top=50, width=1150, height=800, scrollbars=yes, status=yes");
	}

</script>

<body>
<form action="search_cont.jsp" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=1480>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>계약조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td>차량번호 : <input type="text" id="car_no" name="car_no" size="10" value="<%=car_no%>" class=text style='IME-MODE: active' onKeydown="SearchFocus('car_no')">
          &nbsp;
          /
          위반일자 : <input type="text" name="vio_dt" value="<%=vio_dt%>" size="12" class=text onBlur='javscript:this.value = ChangeDate4(this, this.value);' onKeydown="SearchFocus('vio_dt')">
          &nbsp;
          <a href="javascript:search_cont()"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
        </td>        
    </tr>        
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>장기대여</span></td>        
    </tr>    
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="50">연번</td>                  
                  <td class=title width="50">대차</td>
                  <td class=title width="50">탁송</td>                                    
                  <td class=title width="50">상태</td>
                  <td class=title width="90">현차량번호</td>
                  <td class=title width="90">전차량번호</td>
                  <td class=title width="140">차명</td>                  
                  <td class=title width="100">계약번호</td>
                  <td class=title width="200">상호/성명</td>
                  <td class=title width="50">구분</td>                  
		              <td class=title width="80">계약일</td>                  
                  <td class=title width="80">인도일</td>
                  <td class=title width="80">대여개시일</td>
                  <td class=title width="80">대여만료일</td>
                  <td class=title width="80">회수일</td>
                  <td class=title width="80">해지일</td>
                  <td class=title width="130">변경일자</td>
                </tr>
                <%  for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";%>
                <tr> 
                  <td <%=td_color%> align="center"><%=i+1%></td>
                  <td <%=td_color%> align="center"><a href="javascript:view_scont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='대차보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                  <td <%=td_color%> align="center"><a href="javascript:view_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='탁송보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                  <td <%=td_color%> align="center"><%=ht.get("USE_YN_NM")%></td>
                  <td <%=td_color%> align="center"><%=ht.get("CAR_NO")%></td>
                  <td <%=td_color%> align="center"><%=ht.get("CNG_CAR_NO")%></td>
                  <td <%=td_color%> align="center"><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>                  
                  <td <%=td_color%> align="center"><a href="javascript:SetCarRent('<%=ht.get("CAR_ST")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>','<%=ht.get("CAR_NO")%>','<%=ht.get("MNG_ID")%>')"><%=ht.get("RENT_L_CD")%></a></td>
                  <td <%=td_color%> align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></td>
                  <td <%=td_color%> align="center"><%=ht.get("FEE_ST")%></td>                  
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_DELI_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RECO_DT")))%></td>
                  <td <%=td_color%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
                  <td <%=td_color%> align="center"><%=ht.get("CNG_CLS_ST_NM")%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
                  <%if(!String.valueOf(ht.get("CONT_DT")).equals("")){%>
                  <br>[<%=ht.get("CLS_ST")%>] 매매일자 : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")))%>
                  <%}%>
                  <%if(!String.valueOf(ht.get("MIGR_DT")).equals("")){%>
                  <br>[<%=ht.get("CLS_ST")%>] 명의이전일 : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIGR_DT")))%>
                  <%}%>
                  <%=ht.get("PREPARE_NM")%>
                  </td>
                </tr>
                <%	}%>
                <% 	if(cont_size == 0) { %>
                <tr> 
                  <td colspan=17 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
  </tr>
  <tr> 
        <td>&nbsp;</td>
  </tr>
  <tr>
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>