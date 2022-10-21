<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "11");
	
	//if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_car");
	
	int start_year	= AddUtil.getDate2(1)-10;		//표시시작년도
	int end_year 	= AddUtil.getDate2(1);			//현재년도
 		
	Vector vt = new Vector();
	int vt_size = 0;
	
	//실시간데이터
	if(save_dt.equals("")){
		vt = ad_db.getStatCarNow("", start_year, end_year);
	//마감데이터	
	}else{
		vt = ad_db.getStatCarG(save_dt, start_year, end_year);
	}
	
	vt_size = vt.size();
	
	String car_ext = "";
	String car_use = "";
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//세부리스트 이동
	function list_move(s_st, s_year)
	{
		var fm = document.form1;
		var url = "";
		fm.st.value 				= '2';//등록차량
		fm.gubun.value 			= 'init_reg_dt';//검색조건
		fm.q_sort_nm.value 	= 'init_reg_dt';//정렬조건
		fm.ref_dt1.value 		= s_year+'0101';
		fm.ref_dt2.value 		= s_year+'1231';
		if(s_year=='<%=start_year%>')	fm.ref_dt1.value = '20000101';//이전포함
		fm.action = "/acar/car_register/register_s_frame.jsp";
		fm.target = 'd_content';
		fm.submit();
	}		
//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='ref_dt1' value=''>
<input type='hidden' name='ref_dt2' value=''>
<input type='hidden' name='q_sort_nm' value=''>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 자동차관리 > <span class=style5>자동차보유현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 기준일 : <%if(save_dt.equals("")){ %>현재<%} %>
          <input type='text' name='view_dt' size='11' value='<%=AddUtil.ChangeDate2(save_dt)%>' class="white" readonly>
          <font color="#CCCCCC">(2005-08-08부터 말소차량 제외, 차량등록일기준, 단위:대)</font>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>

    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr align="center"> 
            <td colspan="3" class=title>구분</td>
					  <%for(int j = start_year ; j <= end_year ; j++){%>
            <td width=7% class=title><a href="javascript:list_move('0','<%=j%>');" title='자동차관리로 이동'><%=j%>년<%if(j==start_year){%>이전<%}else{%>식<%}%></a></td>
					  <%}%>
            <td width=7% class=title>합계</td>
          </tr>
				  <%
				  	for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
					<%if(i+1 < vt_size && !String.valueOf(ht.get("CAR_EXT_NM")).equals(car_ext)){%>
					<tr>
						<td class=line2 colspan='15'></td> 
					</tr>
					<%}%>
          <tr> 
          	<%if(i+1 == vt_size){%>
          	  <td width="3%" align="center" colspan='3' class=star><%=ht.get("CAR_EXT_NM")%></td>
          	<%}else{%>
              <%if(!String.valueOf(ht.get("CAR_EXT_NM")).equals(car_ext)){%>
              <td width="3%" align="center" rowspan='7'><%=ht.get("CAR_EXT_NM")%></td>
              <%}%>
              <%if(!String.valueOf(ht.get("CAR_USE_NM")).equals(car_use)){%>
              <td width=7% align="center" rowspan=<%if(String.valueOf(ht.get("CAR_USE_NM")).equals("렌트사업용")){%>'3'<%}else{%>'4'<%}%>><%=ht.get("CAR_USE_NM")%></td> <!--rowspan='<%if(String.valueOf(ht.get("CAR_EXT_NM")).equals("렌트사업용")){%>3<%}else{%>4<%}%>'-->
              <%}%>          
              <td width="6%" align="center" <%if(String.valueOf(ht.get("CAR_KD_NM")).equals("소계")){%>class=is<%}%>><%=ht.get("CAR_KD_NM")%></td>
            <%}%>
            <%for(int j = start_year ; j <= end_year ; j++){%>
              <td align="right" <%if(String.valueOf(ht.get("CAR_KD_NM")).equals("소계")){%>class=is<%}else if(String.valueOf(ht.get("CAR_EXT_NM")).equals("총계")){%>class=star<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT_"+(j))))%></td>
					  <%	}%>
            <td align="right" <%if(String.valueOf(ht.get("CAR_KD_NM")).equals("소계")){%>class=is<%}else if(String.valueOf(ht.get("CAR_EXT_NM")).equals("총계")){%>class=star<%}%>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT_T")))%></td>					  
          </tr>
          
					<%	car_ext = String.valueOf(ht.get("CAR_EXT_NM"));
							car_use = String.valueOf(ht.get("CAR_USE_NM"));
				    }
				  %>
        </table>
      </td>    
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>현황 리스트</span></td>
    </tr>
    <tr> 
        <td><iframe src="./stat_car_sc_in_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="50" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
