<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.con_ins.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form name='form1' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
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
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='go_url' value='/acar/con_ins/ins_frame_s.jsp'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<%if(f_list.equals("now")){//납부리스트%>	
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 영업비용관리 > <span class=style5>자동차보험료현황</span></span></td>
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
        <td class='line'> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
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
<%	//보험금 현황
	Vector inss = ac_db.getInsStat(br_id, "", "", "", gubun);
	int ins_size = inss.size();
	if(ins_size > 0){//10 rows
		for (int i = 0 ; i < ins_size ; i++){
			IncomingSBean ins = (IncomingSBean)inss.elementAt(i);%>
                <tr> 
                    <td align="center" class='title'>
			<%if(gubun.equals("")){%>
				<%=ins.getGubun()%>
			<%}else{%>
				<%if(ins.getGubun().substring(0,2).equals("지출")){%>
					수금
				<%}else{%>
					<%=ins.getGubun()%>
				<%}%>
			    <%}%></td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_su1()%>%<% }else{%><%=ins.getTot_su1()%>건<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(ins.getTot_amt1())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_su2()%>%<% }else{%><%=ins.getTot_su2()%>건<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(ins.getTot_amt2())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_su3()%>%<% }else{%><%=ins.getTot_su3()%>건<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%><%=ins.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(ins.getTot_amt3())%>원<%}%>&nbsp;</td>
                    <td align="right"><%if(ins.getSt()==1){%>-<%}else{%><%=Integer.parseInt(ins.getTot_su2())+Integer.parseInt(ins.getTot_su3())%>건<%}%>&nbsp;</td>  
    			    <td align="right">
                  <%if(ins.getSt()==0){%><%=Util.parseDecimal(Util.parseInt(ins.getTot_amt2())+Util.parseInt(ins.getTot_amt3()))%>원<%}else{%>-&nbsp;<%}%>&nbsp;</td>
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
	    <a href="javascript:window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
    </tr>  
	<%}%>  	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
