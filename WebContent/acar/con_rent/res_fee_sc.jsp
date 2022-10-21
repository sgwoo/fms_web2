<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//통화 메모 보기
	function view_memo(s_cd, c_id, rent_st, tm, bus_id){
		var auth_rw = document.form1.auth_rw.value;
		window.open("/acar/con_ins_m/ins_memo_frame_s.jsp?auth_rw="+auth_rw+"&tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=600, height=400");
	}
	
	//세부내용 보기
	function view_rent(s_cd, c_id){
		var fm = document.form1;
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;		
		fm.target = "d_content";
		fm.action = "res_fee_c.jsp";
		fm.submit();
	}
	
	//고객 보기
	function view_cust(s_cd, c_id){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String search_kd = "";
	String brch_id = "";
	String bus_id2 = "";
	
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='s_cd' value=''>
<input type='hidden' name='c_id' value=''>
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td>
      <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		  <td width=100%>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			  <tr>
				<td align='center'>
				  <iframe src="res_fee_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_brch=<%=s_brch%>&s_bus=<%=s_bus%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
				  </iframe>
				</td>
			  </tr>
			</table>
		  </td>
		</tr>
	  </table>
    </td>
  </tr>
  <%if(1!=1){%>
  <tr>      		
    <td class='line'> 
      <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td rowspan="2" width="80" class='title' align="center">구분</td>
          <td colspan="2" class='title' align="center">당월</td>
          <td colspan="2" class='title' align="center">당일</td>
          <td colspan="2" class='title' align="center">연체</td>
          <td colspan="2" class='title' align="center">합계</td>
        </tr>
        <tr align="center"> 
          <td width="70" class='title'>건수</td>
          <td width="100" class='title'>금액</td>
          <td width="70" class='title'>건수</td>
          <td width="100" class='title'>금액</td>
          <td width="70" class='title'>건수</td>
          <td width="100" class='title'>금액</td>
          <td width="70" class='title'>건수</td>
          <td class='title'>금액</td>
        </tr>
<%	//단기대여요금 현황
	Vector clss = rs_db.getScdRentStat(br_id, "", "", "");
	int cls_size = clss.size();
	if(cls_size > 0){
		for (int i = 0 ; i < cls_size ; i++){
			IncomingSBean cls = (IncomingSBean)clss.elementAt(i);%>		
        <tr> 
            <td width="120" align="center" class='title'><%=cls.getGubun()%></td>
            <td width="60"  align="right"><%if(cls.getGubun().equals("비율")){%><%=cls.getTot_su1()%>%<% }else{%><%=cls.getTot_su1()%>건<%}%>&nbsp;</td>
            <td width="100" align="right"><%if(cls.getGubun().equals("비율")){%><%=cls.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt1())%>원<%}%>&nbsp;</td>
            <td width="60"  align="right"><%if(cls.getGubun().equals("비율")){%><%=cls.getTot_su2()%>%<% }else{%><%=cls.getTot_su2()%>건<%}%>&nbsp;</td>
            <td width="100" align="right"><%if(cls.getGubun().equals("비율")){%><%=cls.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt2())%>원<%}%>&nbsp;</td>
            <td width="60"  align="right"><%if(cls.getGubun().equals("비율")){%><%=cls.getTot_su3()%>%<% }else{%><%=cls.getTot_su3()%>건<%}%>&nbsp;</td>
            <td width="100" align="right"><%if(cls.getGubun().equals("비율")){%><%=cls.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(cls.getTot_amt3())%>원<%}%>&nbsp;</td>
            <td width="60"  align="right"> 
              <%if(!cls.getGubun().equals("비율")){%><%=Integer.parseInt(cls.getTot_su2())+Integer.parseInt(cls.getTot_su3())%>건<%}else{%>-&nbsp;<%}%>&nbsp;</td>  
			<td align="right">
              <%if(!cls.getGubun().equals("비율")){%><%=Util.parseDecimal(String.valueOf(Integer.parseInt(cls.getTot_amt2())+Integer.parseInt(cls.getTot_amt3())))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
        </tr>
<%		}
	}else{%>		
		<tr>
			<td colspan="9" align="center">자료가 없습니다.</td>
		</tr>
<%	}%>			
      </table>
    </td>
  </tr>	
  <%}%>
</table>
</form>
</body>
</html>
