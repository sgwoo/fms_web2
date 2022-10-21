<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//세부내용 보기
	function view_scd_tax(m_id, l_cd, c_id, seq, cls_st, gubun, rent_mon)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq.value = seq;		
		fm.cls_st.value = cls_st;		
		fm.rent_mon.value = rent_mon;								
		if(gubun == 'i'){		//일반할부금스케줄 등록
			fm.action = 'tax_scd_i.jsp';
		}else{					//일반할부금스케줄 수정
			fm.action = 'tax_scd_u.jsp';
		}
		fm.target= 'd_content';
		fm.submit();
	}
		
	//스케줄관리 이동
	function tax_scd(){
		var fm = document.form1;
		fm.gubun1.value = '13';
		fm.gubun2.value = '1';
		fm.gubun3.value = '2';		
		fm.gubun4.value = '';				
		fm.st_dt.value = '';
		fm.end_dt.value = '';
//		fm.est_mon.value = '';
		fm.s_kd.value = '0';
		fm.t_wd.value = '';
		fm.sort_gubun.value = '1';
		fm.asc.value = '0';
		fm.f_list.value = 'pay';
		fm.target = "d_content";
		fm.action = "tax_frame_s.jsp";
		fm.submit();
	}		
	
	function view_car_tax(c_id)
	{
		window.open("/fms2/precost/view_tax_car_list.jsp?car_mng_id="+c_id, "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");		
	}			
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='cls_st' value=''>
<input type='hidden' name='rent_mon' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='f_list' value='scd'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
<!--	<tr>
		<td width='800' align='right'>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		
		<a href='javascript:tax_scd()' onMouseOver="window.status=''; return true">개별소비세 납부리스트</a></td>
<%	}%>		
		<td width='20'></td>
	</tr>	-->
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td width=100% colspan='2'>
						<table border="0" cellspacing="0" cellpadding="0" width=100%>
							<tr>
								<td align='center'>
									<iframe src="/acar/con_tax/tax_scd_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
									</iframe>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>