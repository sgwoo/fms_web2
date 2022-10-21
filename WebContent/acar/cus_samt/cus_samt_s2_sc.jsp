<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0401.*, acar.cus_samt.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "04", "04");	
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	String first = request.getParameter("first")==null?"":request.getParameter("first");
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();

	String ven_code = "";	
	ven_code = cs_db.getServOffVenCode(acct);

	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>

<script language="JavaScript">
<!--

//리스트 엑셀 전환 - 
function pop_excel1(s_year, s_mon, s_day, acct){
	var fm = document.form1;
	
	var i_fm = document.inner.form1;
	
	if (s_day == '' ) {
	  	alert("엑셀전환을 할 수 없습니다 !!!, 계산서발행일을 선택하세요!!!");
		return;
	}
	
		
	//데이타 확인 
	if (fm.vt_size.value == '' ) {
	  	alert("엑셀전환을 할 수 없습니다 !!!, 데이타가 없습니다.!!!!");
		return;
	}
	
	//정산회차가 있어야함 -2022-02-24 
	var scd_cnt = 0;
	var scd_size 	= toInt(fm.vt_size.value);	
	
	if ( scd_size < 2) {
		 if (i_fm.set_dt.value == '') {
	    	 scd_cnt=scd_cnt + 1;
	     }	
	} else {	 
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (i_fm.set_dt[i].value == '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	if ( scd_cnt > 0 ) {
		 alert( "정산이 안되어 있는 건입니다. 확인하세요.!!!");
		 return;
	}	
	
	fm.target = "_blank";
	
	fm.action = "popup_excel_multi_service1.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_day=" + s_day+ "&acct=" + acct;
	fm.submit();
}	


//리스트 엑셀 전환 - 
function pop_excel(s_year, s_mon, s_day, acct){
	var fm = document.form1;
	
	var i_fm = document.inner.form1;
	
	if (s_day == '' ) {
	  	alert("엑셀전환을 할 수 없습니다 !!!, 계산서발행일을 선택하세요!!!");
		return;
	}
	
	//데이타 확인 
	if (fm.vt_size.value == '' ) {
	  	alert("엑셀전환을 할 수 없습니다 !!!, 데이타가 없습니다.!!!!");
		return;
	}
	
	//정산회차가 있어야함 -2022-02-24 
	var scd_cnt = 0;
	var scd_size 	= toInt(fm.vt_size.value);	
	
	if ( scd_size < 2) {
		 if (i_fm.set_dt.value == '') {
	    	 scd_cnt=scd_cnt + 1;
	     }		
	} else {	 
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (i_fm.set_dt[i].value == '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	if ( scd_cnt > 0 ) {
		 alert( "정산이 안되어 있는 건입니다. 확인하세요.!!!");
		 return;
	}	
	
	fm.target = "_blank";
	
	fm.action = "popup_excel_multi_service.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_day=" + s_day+ "&acct=" + acct;
	fm.submit();
}	

function make_magam(s_yy, s_mm, s_dd, acct){
	//	var fm = document.form1;
		var fm = document.inner.form1;
		
		if (s_dd == '' ) {
		  	alert("마감을  할 수 없습니다 !!!, 계산서발행일을 선택하세요!!!");
			return;
		}
		
		//데이타 확인 
		if (fm.vt_size.value == '' ) {
		  	alert("마감을 할  수 없습니다 !!!, 데이타가 없습니다.!!!!");
			return;
		}
		
		var acct_dt = s_yy+s_mm+s_dd;
		
		if(!confirm('해당 데이타를 마감하시겠습니까?')){	return;	}
			
		fm.target = "i_no";
	//	fm.action = "cus_samt_s2_magam_a.jsp?acct_dt="+acct_dt+"&acct="+acct;
	
	    if (fm.vt_size.value == '1' ) {
			fm.action = "cus_samt_s2_magam_a1.jsp";
			fm.submit();	
	    } else { 
			fm.action = "cus_samt_s2_magam_a.jsp";
			fm.submit();
	    }
}	


//전표생성
function make_autodocu(s_yy, s_mm, s_dd, acct){
	
	var fm = document.form1;
	
	var i_fm = document.inner.form1;
	
	var acct_dt = s_yy+s_mm+s_dd;
		
	if (s_dd == '' ) {
	  	alert("전표를 생성할 수 없습니다 !!!, 계산서발행일을 선택하세요!!!");
		return;
	}
	//데이타 확인 
	if (fm.vt_size.value == '' ) {
	  	alert("전표를 생성할 수 없습니다 !!!, 데이타가 없습니다.!!!!");
		return;
	}
	
	//정산회차가 있어야함 -2022-02-24 
	var scd_cnt = 0;
	var scd_size 	= toInt(fm.vt_size.value);	
	
	if ( scd_size < 2) {
		 if (i_fm.set_dt.value == '') {
	    	 scd_cnt=scd_cnt + 1;
	     }		
	} else {	 
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (i_fm.set_dt[i].value == '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	if ( scd_cnt > 0 ) {
		 alert( "정산이 안되어 있는 건입니다. 확인하세요.!!!");
		 return;
	}	
	
	if(confirm('전표생성 하시겠습니까?')){
		fm.target = "i_no";
		fm.action = "cus_samt_s2_autodocu_a.jsp?acct_dt="+acct_dt+"&acct="+acct;
		fm.submit();
	}				 	
}

//정비비 정산 확정 처리 
function cal_set_dt(){
	
	var fm = document.inner.form1;
	
	var scd_size 	= toInt(fm.vt_size.value);	
		
	//데이타 확인 
	if (scd_size == 0 ) {
	  	alert("데이타 셋팅 확정을 할 수 없습니다!!!, 데이타가 없습니다.!!!!");
		return;
	}
	
	var scd_cnt = 0;
	
	
	if ( scd_size < 2) {
		 if (fm.r_set_dt.value != '') {
	    	 scd_cnt=scd_cnt + 1;
	     }		
	} else {
	
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (fm.r_set_dt[i].value != '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
//    scd_cnt = 0;
    
	if ( scd_cnt > 0 ) {
		 alert( "정산이 되어있는 건입니다.데이타 셋팅 할 수 없습니다.!!!");
		 return;
	} else {
		if ( scd_size < 2) {
			fm.set_dt.value = fm.cal_set_dt.value; //정산일 계산값		
			fm.jung_st.value = fm.cal_jung_st.value; //정산회차 계산값		
		} else {
			for(var i = 0 ; i < scd_size ; i ++){	
						
				fm.set_dt[i].value = fm.cal_set_dt[i].value; //정산일 계산값		
				fm.jung_st[i].value = fm.cal_jung_st[i].value; //정산회차 계산값		
			}
		}
		
		alert('데이타를 셋팅했습니다.');
	}
}

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='s_year' value='<%=s_year%>'>
  <input type='hidden' name='s_mon' value='<%=s_mon%>'>
  <input type='hidden' name='s_day' value='<%=s_day%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='j_g_amt' value=>
  <input type='hidden' name='j_b_amt' value=>
  <input type='hidden' name='j_g_dc_amt' value=>
  <input type='hidden' name='j_ext_amt' value=>
  <input type='hidden' name='j_dc_amt' value=>
  <input type='hidden' name='acct' value='<%=acct%>'>
  <input type='hidden' name='ven_code' value='<%=ven_code%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>   
  <input type='hidden' name='vt_size' >
   <input type='hidden' name='jung_st' >
   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    
	<td align='right' width=100%>&nbsp;&nbsp;* excel 출력시 인쇄미리보기 가로 75%,  페이지설정에서 왼쪽,오른쪽 여백 0.4 &nbsp;
	<!-- 정산이 안된 경우만 테이타 셋팅 가능  -->	
	&nbsp;<a href="javascript:pop_excel1('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');" >[계산서발행대상]</a>
	&nbsp;<a href="javascript:pop_excel('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>
	<%if ( auth_rw.equals("4") || auth_rw.equals("6") ) {%>	
	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:cal_set_dt();">[데이타셋팅확정]</a>	
<!-- 	&nbsp;<a href="javascript:make_magam('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');"><img src=../images/center/button_mg.gif align=absmiddle border=0></a>	 -->
	&nbsp;<a href="javascript:make_autodocu('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');"><img src=../images/center/button_jpss.gif align=absmiddle border=0></a>
     <% } %>
          
	</td>
  </tr>	
    
  <tr> 
    <td align='center'>
    <iframe src="./cus_samt_s2_sc_in.jsp?first=<%=first%>&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&height=<%=height%>" name="inner" width="100%" height="<%=height +35 %>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe></td>
  </tr>

</table>
</form>
</body>
</html>
