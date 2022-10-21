<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	if(!car_no.equals("")){
		t_wd = car_no;
	}
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	

	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이	

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(s_st){
		var fm = document.form1;
		fm.s_st.value = s_st;
				
		if(s_st == '3'){
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7')		fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8')		fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '11')	fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;			
			
			//수해인 경우 전체로 검색가능하도록 
			if( fm.gubun6.value != '6') {
					
				if (fm.t_wd.value == '') {
			     	alert("검색조건을 입력하셔야 합니다.")
			     	return;
			   }
			}
			
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '3' && fm.t_wd.value != ''){
				fm.gubun2.value = '5';
			}
			
			if(fm.gubun2.value == '5' && fm.t_wd.value == ''){
		     	alert("검색조건을 입력하셔야 합니다.")
		     	return;
			}
		}
				
		fm.action="accid_s_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
	//디스플레이 타입(검색) - 조회기간 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //월별
			td_gubun2_1.style.display	= '';
			td_gubun2_2.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //입력
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= '';
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			fm.st_dt.focus();
		}else{
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= 'none';
		}
	}	
	
	//디스플레이 타입(검색) - 사고유형 선택시
	function cng_input2(){
		var fm = document.form1;
		drop();
		fm.gubun5.options[0] = new Option('전체', '');
		if(fm.gubun4.value == '1'){
			fm.gubun5.options[1] = new Option('대물', '2');
			fm.gubun5.options[2] = new Option('자차', '4');
		}else if(fm.gubun4.value == '2'){
			fm.gubun5.options[1] = new Option('대인', '1');
			fm.gubun5.options[2] = new Option('자손', '3');
		}else if(fm.gubun4.value == '3'){
			fm.gubun5.options[1] = new Option('대물,대인', '5');
			fm.gubun5.options[2] = new Option('대물,자손', '6');
			fm.gubun5.options[3] = new Option('자차,대인', '7');
			fm.gubun5.options[4] = new Option('자차,자손', '8');
		}
	}	
	function drop()
	{
		var fm = document.form1;
		var len = fm.gubun5.length;
		for(var i = 0 ; i < len ; i++){
			fm.gubun5.options[len-(i+1)] = null;
		}
	}			

	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input3(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //접수자,관리담당자,영업담당자
			td_input.style.display	= 'none';
			td_mng.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_mng.style.display	= 'none';
		}
	}	
	
	//사고등록 중복여부확인 리스트
	function AccidRegChk(){
		var fm = document.form1;
		fm.action="reg_chk_accid_list.jsp";
		fm.target="_blank";		
		fm.submit();		
	}	
//-->
</script>
</head>
<body>

<form action="./accid_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 사고관리 > <span class=style5>
						사고조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  

    <tr> 
      
      <td width=20%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif  align=absmiddle>&nbsp;
        <select name="gubun1">
          <option value=""   <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
          <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
          <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
        </select>
      </td>
      <td width=21%>
	  <%if(br_id.equals("S1")){%>
	  <img src=/acar/images/center/arrow_yus.gif  align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;  	  
        <select name='brch_id'>
          <option value=''>전체</option>
          <%if(brch_size > 0){
				for (int i = 0 ; i < brch_size ; i++){
					Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
          <%= branch.get("BR_NM")%> </option>
          <%	}
			}%>
        </select>
		<%}%>		
      </td>
      <td width=13%><img src=/acar/images/center/arrow_jhgg.gif  align=absmiddle>&nbsp;
        <select name="gubun2" onChange="javascript:cng_input1()">
          <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
          <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당월</option>
          <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>당해</option>
          <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>직접입력</option>
        </select>
      </td>
      <td width=15%> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td id='td_gubun2_1' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
	          <select name="s_mon">
			  <%for(int i=1; i<13; i++){%>
	            <option value="<%=i%>" <%if(st_dt.equals(Integer.toString(i))){%>selected<%}%>><%=i%>월</option>
			  <%}%>
	          </select>
            </td>
            <td id='td_gubun2_2' <%if(gubun2.equals("5")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
              <input type="text" name="st_dt" size="11" value="<%=st_dt%>" class="text" >
              ~ 
              <input type="text" name="end_dt" size="11" value="<%=end_dt%>" class="text" >
            </td>			
          </tr>
        </table>
      </td>
      <td></td>
    </tr>
    <tr> 

      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_sgcr.gif  align=absmiddle>&nbsp;
        <select name="gubun3">
          <option value=""   <%if(gubun3.equals("")){%>selected<%}%>>전체</option>
          <option value="0" <%if(gubun3.equals("0")){%>selected<%}%>>진행</option>
          <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>종결</option>
        </select>
      </td>
    
      <td><img src=/acar/images/center/arrow_g_acc.gif  align=absmiddle> &nbsp;
        <select name="gubun4" onChange="javascript:cng_input2()">
          <option value=""   <%if(gubun4.equals("")){%>selected<%}%>>전체</option>
          <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>물적사고</option>
          <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>인적사고</option>
          <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>복합사고</option>
          <option value="4" <%if(gubun4.equals("4")){%>selected<%}%>>없음</option>		  
        </select>&nbsp;
        <select name="gubun5">
          <option value=""   <%if(gubun5.equals("")){%>selected<%}%>>전체</option>
          <%if(gubun4.equals("1")){%>
          <option value="2" <%if(gubun5.equals("2")){%>selected<%}%>>대물</option>
          <option value="4" <%if(gubun5.equals("4")){%>selected<%}%>>자차</option>
          <%}else if(gubun4.equals("2")){%>
          <option value="1" <%if(gubun5.equals("1")){%>selected<%}%>>대인</option>
          <option value="3" <%if(gubun5.equals("3")){%>selected<%}%>>자손</option>
          <%}else if(gubun4.equals("3")){%>
          <option value="5" <%if(gubun5.equals("5")){%>selected<%}%>>대물,대인</option>
          <option value="6" <%if(gubun5.equals("6")){%>selected<%}%>>대물,자손</option>
          <option value="7" <%if(gubun5.equals("7")){%>selected<%}%>>자차,대인</option>
          <option value="8" <%if(gubun5.equals("8")){%>selected<%}%>>자차,자손</option>
          <%}%>
        </select>
      </td>
   
      <td><img src=/acar/images/center/arrow_bsci.gif  align=absmiddle>&nbsp;
        <select name="gubun6">
          <option value=""   <%if(gubun6.equals("")){%>selected<%}%>>전체</option>
          <option value="1" <%if(gubun6.equals("1")){%>selected<%}%>>피해</option>
          <option value="2" <%if(gubun6.equals("2")){%>selected<%}%>>가해</option>
          <option value="3" <%if(gubun6.equals("3")){%>selected<%}%>>쌍방</option>
          <option value="8" <%if(gubun6.equals("8")){%>selected<%}%>> 단독</option>		  
          <option value="6" <%if(gubun6.equals("6")){%>selected<%}%>>수해</option>		  
	  
        </select>
      </td>
      <td>&nbsp;</td>
      <td></td>
    </tr>
    <tr> 
  
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp;   
        <select name="s_kd" onChange="javascript:cng_input3()">
          <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>계약번호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>상호</option>
          <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>차량번호</option>
          <option value="7" <%if(s_kd.equals("7")){%> selected <%}%>>접수자</option> 
          <option value="8" <%if(s_kd.equals("8")){%> selected <%}%>>관리담당자</option> 
	       <option value="11" <%if(s_kd.equals("11")){%> selected <%}%>>영업담당자</option> 
	  	    <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>차명</option> 
        </select>
      </td>
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td id='td_input' <%if(s_kd.equals("7")||s_kd.equals("8")||s_kd.equals("11")){%>style='display:none'<%}else{%> style="display:''"<%}%>> 
              <input type="text" name="t_wd" size="21" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
            </td>
            <td id='td_mng' <%if(s_kd.equals("7")||s_kd.equals("8")||s_kd.equals("11")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
              <select name='s_mng'>
                    <option value="">미지정</option>
                    <%	if(user_size > 0){
				for(int i = 0 ; i < user_size ; i++){
					Hashtable user = (Hashtable)users.elementAt(i); 
		    %>
		    <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
	            <%		}
			}
		    %>
        	    <option value="">=퇴사자=</option>
                    <%	if(user_size2 > 0){
        			for (int i = 0 ; i < user_size2 ; i++){
        				Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                    <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
                    <%		}
        		}%>			    
                 </select> </td>                        
          </tr>
        </table>
      </td>
      <td colspan="2"><img src=/acar/images/center/arrow_jr.gif  align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(sort.equals("2")){%> selected <%}%>>차량번호</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>차명</option>
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>사고일자</option>
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search(3)'>
        오름차순 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search(3)'>
        내림차순 </td>
      <td><a href="javascript:Search(3)"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
      &nbsp;&nbsp;
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <a href="javascript:AccidRegChk()">[중복등록분]</a>
	  <%}%>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
