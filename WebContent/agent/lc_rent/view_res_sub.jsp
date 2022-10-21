<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	
//-->	
</script>
</head>
<body leftmargin="15">
<%
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

	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_start_dt = request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt = request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	//차량정보
	Hashtable res = rs_db.getCarInfo(c_id);
	
	//예약현황
	Vector conts = rs_db.getResCarList2(c_id);
	int cont_size = conts.size();
%>
<form name="form1" method="post" action="res_rent_i.jsp">
<input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'> 
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>   
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>   
 <input type='hidden' name='code' value='<%=code%>'>     
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'> 
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' value='<%=asc%>'> 
 <input type='hidden' name='rent_start_dt' value=''>
 <input type='hidden' name='rent_end_dt' value=''>
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > <span class=style5>차량별 예약/대여 리스트</span></span></td>
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
                    <td class=title>차량번호</td>
                    <td> 
                      &nbsp;<%=res.get("CAR_NO")%>
                    </td>
                    <td class=title>차명</td>
                    <td align="left" colspan="3">&nbsp;<%=res.get("CAR_NM")%>&nbsp;<%=res.get("CAR_NAME")%></td>
                    <td class=title>차대번호</td>
                    <td align="left" colspan="3">&nbsp;<%=res.get("CAR_NUM")%></td>
                </tr>
                <tr> 
                    <td class=title width=9%>최초등록일</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("INIT_REG_DT")))%></td>
                    <td class=title width=8%>출고일자</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("DLV_DT")))%></td>
                    <td class=title width=14%>배기량</td>
                    <td width=9%>&nbsp;<%=res.get("DPM")%>cc</td>
                    <td class=title width=9%>칼라</td>
                    <td width=9%>&nbsp;<%=res.get("COLO")%></td>
                    <td class=title width=7%>연료</td>
                    <td width=13%>&nbsp;<%=res.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>선택사양</td>
                    <td colspan="3">&nbsp;<%=res.get("OPT")%></td>
                    <td class=title>현재예상주행거리</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(res.get("TODAY_DIST")))%>km</td>
                    <td class=title>최종점검일</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="12%">보유차</td>
                    <td class=title width="12%">차량번호</td>			
                    <td class=title width="9%">구분</td>
                    <td class=title width="6%">상태</td>
                    <td class=title width="37%">대여기간</td>
                    <!--<td class=title width="100">계약자</td>-->
                    <td class=title width="19%">상호</td>
                    <!--<td class=title width="50">스케줄</td>-->
                </tr>
                <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("CAR_NO")%></td>			
                    <td align="center"><%=reservs.get("SUB_CAR_NO")%></td>						
                    <td align="center"><%=reservs.get("RENT_ST")%></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>시 ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%>시</td>                    
                    <td align="center"><%=reservs.get("FIRM_NM")%></td>        		
                </tr>
                <%		}
      			}else{%>
                <tr> 
                    <td colspan='8' align='center'>등록된 데이타가 없습니다</td>
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
