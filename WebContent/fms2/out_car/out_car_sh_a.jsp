<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	int gubun4 = request.getParameter("gubun4")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("gubun4"));	
	int gubun6 = request.getParameter("gubun6")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("gubun6"));	
	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String idx_gubun = request.getParameter("idx_gubun")==null?"":request.getParameter("idx_gubun");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	//디스플레이 타입-대분류
	function cng_input(){
		var fm = document.form1;
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '1'){ //기간
			td_a.style.display	= '';
			td_b.style.display	= 'none';
		}else if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '2'){ //명칭
			td_a.style.display	= 'none';
			td_b.style.display	= '';
		}else{
			td_a.style.display	= 'none';
			td_b.style.display	= 'none';
		}
	}	

//디스플레이 타입-중분류
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '2'){ //특정일자
			td_a1.style.display	= '';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //월간단위
			td_a1.style.display	= 'none';
			td_b1.style.display	= '';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //년간단위
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= '';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '6'){ //조회기간
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= '';
		}else{			
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
		}
		//search();
	}	
	
	//수금 스케줄 리스트 이동
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
		fm.gubun4.value = "";		
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/out_car/out_car_frame_a.jsp";
		else if(idx == '2') url = "/fms2/out_car/out_car_frame_b.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='/fms2/out_car/out_car_sc.jsp' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='idx_gubun' value='<%=idx_gubun%>'>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>자체출고현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
            	<tr>
					<td >&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
						<select name='gubun1' onChange="javascript:list_move()">
							<option value="0">선택</option>
							<option value="1" selected >기간</option>
							<option value="2">명칭</option>
						</select>
					</td>
					<td>
					    <select name="gubun7">
							<option value=""  <%if(gubun7.equals(""))%>selected<%%>>출고일</option>
							<option value="2" <%if(gubun7.equals("2"))%>selected<%%>>계약일</option>
						</select>
						&nbsp;
						<select name="gubun2" onChange="javascript:cng_input1()">
							<option value="1" <%if(gubun2.equals("1"))%>selected<%%>>전체기간</option>
							<option value="2" <%if(gubun2.equals("2"))%>selected<%%>>특정일자</option>

							<option value="4" <%if(gubun2.equals("4"))%>selected<%%>>월간단위</option>
							<option value="5" <%if(gubun2.equals("5"))%>selected<%%>>년간단위</option>
							<option value="6" <%if(gubun2.equals("6"))%>selected<%%>>지정일자</option>
						</select>
					</td>
					<td id='td_a1' <%if(gubun2.equals("2")){%> style='display:none'<%}%>>	
						<select name="gubun3">
							<option value="1" <%if(gubun3.equals("1"))%>selected<%%>>전전일</option>
							<option value="2" <%if(gubun3.equals("2"))%>selected<%%>>전일</option>
							<option value="3" <%if(gubun3.equals("3"))%>selected<%%>>당일</option>
						</select>
					</td>
					<td id='td_b1' <%if(gubun2.equals("4")){%> style='display:none'<%}%>>	
						<select name="gubun4" >
							<%for(int i=2006; i<=year; i++){%>
							<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
							<%}%>
						</select>
						<select name="gubun5">
							<option value="" <%if(gubun5.equals("")){%> selected <%}%>>전체</option>
							<% for(int i=1; i<=12; i++){%>
							<option value="<%=AddUtil.addZero2(i)%>" <%if(s_month == i){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
							<%}%>
						</select>
					</td> 	
					<td id='td_c1' <%if(gubun2.equals("5")){%> style='display:none'<%}%>>	
						<select name="gubun6">
						<%for(int i=2006; i<=year; i++){%>
						<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
					</td>	
					<td id='td_d1' <%if(gubun2.equals("6")){%> style='display:none'<%}%>>	
							<input type='text' name='t_st_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'> 
						~
							<input type='text' name='t_end_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'>
					</td>
					<td>
						<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
				
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>