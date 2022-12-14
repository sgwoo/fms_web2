<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.account.*, acar.forfeit_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//통화 메모 보기
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		var auth_rw = document.form1.auth_rw.value;
		window.open("/acar/con_ins_m/ins_memo_frame_s.jsp?auth_rw="+auth_rw+"&tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=600, height=400");
	}	
	
	//과태금 세부내용 보기
	function view_forfeit(m_id, l_cd, c_id, seq_no){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq_no.value = seq_no;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//고객 보기
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	//엑셀 
	function pop_excel(){
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("엑셀로 출력할 계약을 선택하세요.");
			return;
		}	
		fm.target = "_blak";
		fm.action = "popup_excel.jsp";
		fm.submit();
	}		

	//등록
	function reg_forfeit(){
		var fm = document.form1;
		fm.target = "d_content";
//		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.action = "/acar/fine_mng/fine_mng_frame.jsp";		
		fm.submit();
	}
	
	//수금관리 이동
	function forfeit_in(){
		var fm = document.form1;
		fm.gubun2.value = '6';
		fm.target = "d_content";
		fm.action = "/acar/con_forfeit/forfeit_frame_s.jsp";
		fm.submit();
	}	
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
		document.form1.action="forfeit_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"10":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	if(user_id.equals("")){
		user_id=login.getCookieValue(request, "acar_id");
	}
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<input type='hidden' name='seq_no' value=''>
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
<input type='hidden' name='f_list' value='out'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;고객지원 > 과태료관리 > <span class=style1><span class=style5>과태료 합계표</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>      		
        <td class='line'> 
            <table width="800" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=16% class='title' align="center">구분</td>
                    <td colspan="2" class='title' align="center">당월</td>
                    <td colspan="2" class='title' align="center">당일</td>
                    <td colspan="2" class='title' align="center">연체</td>
                    <td colspan="2" class='title' align="center">합계</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                </tr>
<%	//과태료 현황
	Vector fines = ac_db.getFinePreExpStat(br_id, "", "", "");
	int fine_size = fines.size();
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			IncomingSBean fine = (IncomingSBean)fines.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=fine.getGubun()%></td>		
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su1()%>%<% }else{%><%=fine.getTot_su1()%>건<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su2()%>%<% }else{%><%=fine.getTot_su2()%>건<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_su3()%>%<% }else{%><%=fine.getTot_su3()%>건<%}%>&nbsp;</td>
                    <td align="right"><%if(fine.getSt()==1){%><%=fine.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fine.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"> 
                      <%if(fine.getSt()==0){%><%=Integer.parseInt(fine.getTot_su2())+Integer.parseInt(fine.getTot_su3())%>건<%}else{%>-&nbsp;<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(fine.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(fine.getTot_amt2())+Util.parseInt(fine.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>		
		        <tr>
			        <td colspan="10" align="center">자료가 없습니다.</td>
		        </tr>
<%	}%>	
            </table>
        </td>
    </tr>	
    <tr>
	    <td align="right">
	        <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
    </tr>  
</table>
</form>
</body>
</html>
