<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cus0401.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"4":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"":request.getParameter("acct");
		
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--
function view_detail(car_mng_id,rent_mng_id,rent_l_cd)
{
	var fm = document.form1;
	var url = "?car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>";
	parent.location.href = "cus0401_d_sc_carinfo.jsp"+url+url2;
}

function view_client(client_id,cmd)
{
	var fm = document.form1;
	var url = "?client_id="+client_id+"&cmd="+cmd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>";
	parent.location.href = "/acar/cus0402/cus0402_d_sc_clientinfo.jsp"+url+url2;
}

	
function list_move(gubun1, gubun2, gubun3)
{
		var fm = document.form1;
		var url = "/acar/cus0401/cus0401_s_frame.jsp?gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3;
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
}

//리스트 엑셀 전환
function pop_excel(s_year, s_mon, s_kd, t_wd){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_excel_service.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_kd=" + s_kd+ "&t_wd=" + t_wd;
	fm.submit();
}	


function make_magam(s_yy, s_mm, s_seq){
		var fm = document.form1;
		
		if(!confirm('해당월 정산회차를 마감하시겠습니까?')){	return;	}
			
		fm.target = "i_no";
		fm.action = "cus_samt_magam_a.jsp?s_yy="+ s_yy + "&s_mm="+ s_mm + "&s_seq=" + s_seq;
		fm.submit();
}	


//결재문서기안
	function select_jung()
	{
		
		if (document.form1.acct.value == '') {
		 	alert("정비업체 선택후 조회하세요.");
			return;
		}
		
		//정비월 선택
	//	if (document.form1.s_kd.value == '4' &&  document.form1.t_wd.value != '') {
	//	} else {
	//	 	alert("검색조건을 정비년월로 선택후 조회하세요.");
	//		return;
	//	}
				
		if (document.form1.set_dt.value == '') {
		 	alert("정산일자를 선택하세요.");
			return;
		}
		      
		if (document.form1.jung_st.value == '') {
		 	alert("정산회차를 선택하세요.");
			return;
		}
		      
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("정산할 정비를 선택하세요.");
			return;
		}			
		
		if(!confirm('정산 마감하시겠습니까?')){	return;	}
		
//		fm.target = "i_no";
		fm.target = "d_content";
		fm.action = "cus_set_dt_conf_a.jsp?auth_rw="+document.form1.auth_rw.value + "&set_dt="+document.form1.set_dt.value+"&jung_st="+document.form1.jung_st.value;
		fm.submit();		
	}		
	
	
	//정산회차 계산
	function set_jung(){
		var fm = document.form1;	
		
		if(fm.set_dt.value == ''){ 	alert('정산일자를 입력하십시오'); 	return;	}
	
		if(!isDate(fm.set_dt.value)){ fm.set_dt.focus(); return;	}	
		
		//tot_dist 초기화 
		fm.jung_st.value = "";
				
		fm.action='./select_c_nodisplay.jsp';						
				
		fm.target='i_no';
		fm.submit();
	}	
	

//-->
</script>
</head>

<body>
<form  name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='s_year' value='<%=s_year%>'>
  <input type='hidden' name='s_mon' value='<%=s_mon%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>

  <input type='hidden' name='acct' value='<%=acct%>'>
    
<table width="100%" border="0" cellspacing="1" cellpadding="0">
  <tr>
	<tr>
			 <td align='left'>
			  <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>   
				<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정산일자</span>&nbsp;<input type='text' name="set_dt"  size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '> &nbsp;&nbsp;&nbsp;
				<span class=style2>정산회차</span>&nbsp;
				    <select name='jung_st'>
				    	    <option value=''> -선택- </option>
			    			<option value='1'> 1회차 </option>
			    			<option value='2'> 2회차 </option>
			    			<option value='3'> 3회차 </option>
			    			<option value='4'> 4회차 </option>
			    			<option value='5'> 5회차 </option>
			    			<option value='6'> 6회차 </option>
			    			<option value='7'> 7회차 </option>
			    			<option value='8'> 8회차 </option>
			    			<option value='9'> 9회차 </option> 
			    			<option value='10'> 10회차 </option>
			    			<option value='11'> 11회차 </option>
			    			<option value='12'> 12회차 </option>
			    			<option value='13'> 13회차 </option>
			    			<option value='14'> 14회차 </option>
			    			<option value='15'> 15회차 </option>
			    			<option value='16'> 16회차 </option>
			    			<option value='17'> 17회차 </option>
			    			<option value='18'> 18회차 </option>
			    			<option value='19'> 19회차 </option>
			    			<option value='20'> 20회차 </option>
			    			<option value='21'> 21회차 </option>
			    			<option value='22'> 22회차 </option>
			    			<option value='23'> 23회차 </option>
			    			<option value='24'> 24회차 </option>
			    			<option value='25'> 25회차 </option>
			    			<option value='26'> 26회차 </option>
			    			<option value='27'> 27회차 </option>
			    			<option value='28'> 28회차 </option>
			    			<option value='29'> 29회차 </option>
			    			<option value='30'> 30회차 </option>   			
			    	</select>&nbsp;&nbsp;&nbsp;	
			<!--  	<a href="javascript:select_jung();"><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;	-->			 
				 
	 		 <%}%>						
			</td>
		
  </tr>	
  <tr> 
    <td><iframe src="./cus_samt_n1_sc_in.jsp?height=<%=height%>&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&sh_height=<%=sh_height%>" name="inner" width="100%" height="<%=height+10 %>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe></td>
  </tr>

</table>
</form>
</body>
</html>
