<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*, acar.consignment.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "01");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_start_dt = request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt = request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	
	
	//차량정보
	Hashtable res = rs_db.getCarInfo(c_id);
	
	//탁송현황
	Vector vt = cs_db.getConsignmentMngList("c_id", c_id, "2", "", "", "");
	int vt_size = vt.size();
		
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>

</script>
</head>
<body leftmargin="15">

<form name="form1" method="post" action="">
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예약조회 > <span class=style5>탁송현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="10%">차량번호</td>
                    <td width="40%">&nbsp;<%=res.get("CAR_NO")%></td>
                    <td class=title width="10%">차명</td>
                    <td align="left" width="40%">&nbsp;<%=res.get("CAR_NM")%>&nbsp;<%=res.get("CAR_NAME")%></td>                    
                </tr>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="4%">연번</td>
                    <td class=title width="13%">탁송업체</td>
                    <td class=title width="14%">탁송사유</td>
                    <td class=title width="17%">상호</td>										
                    <td class=title width="15%">출발지</td>
                    <td class=title width="8%">출발시간</td>					
                    <td class=title width="15%">도착지</td>					
                    <td class=title width="8%">도착시간</td>
                    <td class=title width="6%">의뢰자</td>			
                </tr>
              <%	if(vt_size > 0)	{
    				for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("OFF_NM")%></td>
                    <td align='center'><%=ht.get("CONS_CAU_NM")%></td>
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("FROM_PLACE")%></td>
		    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("F_DT")))%></td>
		    <td align='center'><%=ht.get("TO_PLACE")%></td>
		    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("T_DT")))%></td>
		    <td align='center'><%=ht.get("USER_NM1")%></td>
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='10' align='center'>등록된 데이타가 없습니다</td>
                </tr>
              <%	}%>
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
