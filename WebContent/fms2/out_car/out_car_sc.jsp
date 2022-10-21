<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*, acar.out_car.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	String gubun = request.getParameter("gubun")==null?"2":request.getParameter("gubun");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String fn_id= "0";
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	//String [] rcst = cdb.getRegCondSta(gubun,dt,t_st_dt,t_end_dt,br_id,fn_id);
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String idx_gubun = request.getParameter("idx_gubun")==null?"":request.getParameter("idx_gubun");
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-70;//현황 라인수만큼 제한 아이프레임 사이즈
	
	Vector deb1s = oc_db.getStatDebtList("OUT_CAR_MAGAM");
	int deb1_size = deb1s.size();
	
	String search_dt = "";
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--

function view_cont(m_id, l_cd)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '4'; /*조회*/
		fm.g_fm.value = '1';
		fm.submit();
	}

	function magam_save(today){
		var fm = document.form1;	
		if(!confirm('마감 하시겠습니까?')){	
			return;	
		}
		fm.action = 'out_car_magam_save_a.jsp?save_dt='+today;						
		fm.target = 'i_no';
		fm.submit();	
	}
	
	function magam_search(save_dt){
		var fm = document.form1;		
		fm.action = "out_car_magam_list.jsp";
		fm.target='_blank';
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
	 <input type='hidden' name='gubun1' value='<%=gubun1%>'>
	 <input type='hidden' name='user_id' value='<%=user_id%>'>
	 <input type='hidden' name='br_id' value='<%=br_id%>'>
	 <input type='hidden' name='idx_gubun' value='<%=idx_gubun%>'>
	 <input type='hidden' name='gubun4' value='<%=gubun4%>'>
	 <input type='hidden' name='gubun5' value='<%=gubun5%>'>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
        <td align="left">
			<a href="#" onClick="window.open('./out_car_print.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>')"><img src=/acar/images/center/button_print.gif border=0 align=absmiddle></a>
			
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;마감일자
			<select name="save_dt">
			<%
			for(int i = 0 ; i < deb1_size ; i++){
				Out_carBean sd = (Out_carBean)deb1s.elementAt(i);	
					
					
					if(idx_gubun.equals("A")||idx_gubun.equals("B")){
						save_dt = String.valueOf(sd.getSave_dt());
					}
				%>	
				<option value="<%=sd.getSave_dt()%>"><%=sd.getSave_dt()%></option>
			<%	}			%>
			</select>
			<a href="javascript:magam_search()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a> 
			<a href="javascript:magam_save('<%=save_dt%>');"><img src=/acar/images/center/button_dimg.gif border=0 align=absmiddle></a>
		</td>
    </tr>
	
	
	<%if(idx_gubun.equals("A")||idx_gubun.equals("B")){%>
    <tr>
		<%
		if(!gubun4.equals("")&&!gubun5.equals("")){
			search_dt = gubun4+"-"+gubun5+"-01";
		}else{
			search_dt = AddUtil.getDate();
		}
		if(oc_db.getServiceCheck(search_dt) == 0 ){
		%>	  
    	<td><iframe src="/fms2/out_car/out_car_sc_in2.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&save_dt=<%=save_dt%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
		<%}else{%>			
		<td><iframe src="/fms2/out_car/out_car_sc_in3.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&save_dt=<%=save_dt%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
		<%}%>			
    </tr>
	<%}else{%>
	<tr>
    	<td><iframe src="/fms2/out_car/out_car_sc_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&dt=<%=dt%>&t_st_dt=<%=t_st_dt%>&t_end_dt=<%=t_end_dt%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&save_dt=<%=save_dt%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td>
    </tr>
	<%}%>
	
	
	<tr>
		<td><img src="/../images/blank.gif" height="2"></td>
	</tr>
</table>
</form>
</body>
</html>