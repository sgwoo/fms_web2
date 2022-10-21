<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	
	//예약현황
	Vector conts = rs_db.getResCarCauCarList(c_id);
	int cont_size = conts.size();
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//예약이력	
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=c_id%>";  	
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes"); 		
	}
	
	//팝업윈도우 열기
	function parking_car(car_mng_id, io_gubun, st)
	
	{
		window.open("/fms2/park_home/parking_check_frame.jsp?car_mng_id="+car_mng_id+"&io_gubun="+io_gubun+"&st="+st, "PARKING_CAR", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}	
//-->
</script>
</head>
<body leftmargin="15">

<form name="form1" method="post" action="res_rent_i.jsp">
<input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예약조회 > <span class=style5>차량별 예약/대여 리스트</span></span></td>
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
                    <td class=title width=10%>최초등록일</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("INIT_REG_DT")))%></td>
                    <td class=title width=13%>출고일자</td>
                    <td width=9%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("DLV_DT")))%></td>
                    <td class=title width=10%>배기량</td>
                    <td width=9%>&nbsp;<%=res.get("DPM")%>cc</td>
                    <td class=title width=10%>칼라</td>
                    <td width=9%>&nbsp;<%=res.get("COLO")%></td>
                    <td class=title width=6%>연료</td>
                    <td width=13%>&nbsp;<%=res.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>선택사양</td>
                    <td colspan="3">&nbsp;<%=res.get("OPT")%></td>
                    <td class=title>주행거리</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(res.get("TODAY_DIST")))%>km</td>
                    <td class=title>최종점검일</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("SERV_DT")))%></td>
                </tr>
				<tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=23% colspan="3">&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("MAINT_ST_DT")))%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("MAINT_END_DT")))%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("CAR_END_DT")))%>" size="10" class=whitetext>
                    </td>
                    <td class=title>점검유효기간</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("TEST_ST_DT")))%>" size="10" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("TEST_END_DT")))%>" size="10" class=whitetext>
                    </td>
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
                    <td class=title rowspan='2' width="4%">연번</td>
                    <td class=title rowspan='2' width="7%">관리번호</td>
                    <td class=title rowspan='2' width="6%">구분</td>
                    <td class=title rowspan='2' width="4%">상태</td>
                    <td class=title colspan='2'>자동차</td>					
                    <td class=title rowspan='2' width="18%">대여기간</td>
                    <td class=title rowspan='2' width="26%">상호/성명</td>
                    <td class=title rowspan='2' width="5%">담당자</td>
                    <td class=title rowspan='2' width="5%">등록자</td>
                    <td class=title rowspan='2' width="9%">등록일자</td>
                </tr>
				<tr>
                    <td class=title width="8%">보유차</td>														
                    <td class=title width="8%">사유발생</td>																			
				</tr>
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("RENT_S_CD")%></td>
                    <td align="center"><%=reservs.get("RENT_ST")%></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("CAR_NO")))){%><font color=red><%}%><%=reservs.get("CAR_NO")%><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("CAR_NO")))){%></font><%}%></td>
                    <td align="center"><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("D_CAR_NO")))){%><font color=red><%}%><%=reservs.get("D_CAR_NO")%><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("D_CAR_NO")))){%></font><%}%></td>										
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>시 ~ <br><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%>시</td>
                    <td align="center"><a class=index1 href="javascript:MM_openBrWindow('/acar/rent_diary/rent_cont.jsp?c_id=<%=c_id%>&s_cd=<%=reservs.get("RENT_S_CD")%>&car_no=<%=res.get("CAR_NO")%>','RentCont','scrollbars=yes,status=yes,resizable=yes,width=850,height=550,left=10, top=10')"><%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%></a></td>
                    <td align="center"><%=reservs.get("BUS_NM")%></td>
                    <td align="center"><%=reservs.get("REG_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3_2(String.valueOf(reservs.get("REG_DT")))%></td>										
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='11' align='center'>등록된 데이타가 없습니다</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>* 장기대기로 예약되었다가 취소된 건은 미포함하였습니다.&nbsp;</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>    	
    <tr> 
        <td>[재리스상담<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>]&nbsp;        
            <a href="javascript:parking_car('<%=c_id%>', '1', '1')" onMouseOver="window.status=''; return true" hover>[주차장현황]</a>
        </td>
    </tr>    	

</table>
</form>
</body>
</html>
