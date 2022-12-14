<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"2":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String o_c_id = request.getParameter("o_c_id")==null?"":request.getParameter("o_c_id");//자동차관리번호
	String o_ins_st = request.getParameter("o_ins_st")==null?"":request.getParameter("o_ins_st");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고구분
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");//사고구분
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");//사고구분
	
	if(s_kd.equals("")) s_kd = "2";
	
	//조회
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = new Vector();
	int accid_size = 0;
	
	if(!t_wd.equals("")){
		accids = as_db.getRentList(br_id, s_gubun1, s_kd, t_wd);
		accid_size = accids.size();
	}
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//계약선택
	function Disp(c_id, car_no, car_nm, car_num, init_reg_dt){
		opener.document.form1.car_mng_id.value 	= c_id;
		opener.document.form1.car_no.value 		= car_no;
		opener.document.form1.car_nm.value 		= car_nm;				
		opener.document.form1.car_num.value 	= car_num;						
		opener.document.form1.init_reg_dt.value = init_reg_dt;								
		self.close();
	}	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search_succ.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>
<input type='hidden' name="s_gubun2" value='<%=s_gubun2%>'>
<input type='hidden' name="s_gubun3" value='<%=s_gubun3%>'>
<input type='hidden' name="o_c_id" value='<%=o_c_id%>'>
<input type='hidden' name="o_ins_st" value='<%=o_ins_st%>'>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='mode' value=''>
<table width="750" border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > <span class=style5>계약조회리스트</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>    	
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
          <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>계약번호</option>		  
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
          <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>차대번호</option>		  
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()">
        <a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=750>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="40">구분</td>
            <td class=title width="100">계약번호</td>
            <td class=title width="150">상호</td>
            <td class=title width="100">차량번호</td>
            <td class=title width="100">차대번호</td>			
            <td class=title width="150">계약기간</td>
            <td class=title width="80">해지일자</td>
          </tr>
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
          <tr align="center"> 
            <td><%=i+1%></td>
            <td> 
              <%if(accid.get("USE_YN").equals("Y")){%>
              대여 
              <%}else{%>
              해지 
              <%}%>
            </td>
            <td><a href="javascript:Disp('<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("CAR_NO")%>', '<%=accid.get("CAR_NM")%>', '<%=accid.get("CAR_NUM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(accid.get("INIT_REG_DT")))%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a></td>
            <td><%=accid.get("FIRM_NM")%></td>
            <td><%=accid.get("CAR_NO")%></td>
            <td><%=accid.get("CAR_NUM")%></td>			
            <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_END_DT")))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("CLS_DT")))%></td>
          </tr>
          <%		}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>