<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
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
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
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
	
	//조회
	InsComDatabase ic_db = InsComDatabase.getInstance();
	Vector accids = new Vector();
	int accid_size =0;
	if(!t_wd.equals("")){
		accids = ic_db.getRentList(s_kd, t_wd, gubun3, st_dt, end_dt);
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
	function reg() {
		var fm = document.form1;	

		var car_mng_id = new Array();
		var ins_st = new Array();
		
		var chklen = fm.chk.length;
		var trueCount = 0;
		
		
		for(i=0; i< chklen; i++){
			if(fm.chk[i].checked == true){
				trueCount++;
			 }
		}
		
		if(!chklen){
			var chval = fm.chk.value;
			if(chval)trueCount++;
		}
		
		if(trueCount>0){
			fm.action = "ins_com_filereq_add.jsp";		
		 	fm.submit(); 
		}else{
			alert("해당 리스트를 체크해주세요");
			return;
		}
	}
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.chk.length;
		var cnt = 0;
		var idnum ="";
		var allChk = fm.ch_all;
		 for(var i=0; i<len; i++){
			var ck = fm.chk[i];
			 if(allChk.checked == false){
				ck.checked = false;
			}else{
				ck.checked = true;
			} 
		} 
	}	
	function gubun3Change(val){
		var fm = document.form1;
	  	if(val == '기간'){
	  		var date = new Date();
	  		fm.st_dt.value =getFormatDate(date)-3;
	  		fm.end_dt.value = getFormatDate(date);
		}else{
			fm.st_dt.value ="";
	  		fm.end_dt.value = "";
		} 
	}
	
	function getFormatDate(date){
		var year = date.getFullYear();                 
		return  year;
	}
	
	
	//계약선택
/* 	function Disp(m_id, l_cd, c_id){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;

		window.open("about:blank", "add", "left=350, top=250, width=1020, height=600, scrollbars=yes");
		fm.action = "ins_com_filereq_add.jsp";		
		fm.target = "add";
		fm.submit();
	}	 */
</script>
</head>

<body>
<form name='form1' method='post' action='/fms2/ins_com/search.jsp'>

<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='ins_st' value=''>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>보험조회리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;<img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;
		<select id="gubun3" name="gubun3" style="width:70px;"  onchange="gubun3Change(this.value)">
			<option value=''>전체</option>
			<option value='당해' <%if(gubun3.equals("당해")){%>selected<%}%>>당해</option>
			<option value='전년' <%if(gubun3.equals("전년")){%>selected<%}%>>전년</option>
			<option value='기간' <%if(gubun3.equals("기간")){%>selected<%}%>>기간</option>		
		</select>	
		<input type="text" name="st_dt" size="6" maxlength="4" value="<%=st_dt%>" class="text" >
	  	~ 
	  	<input type="text" name="end_dt" size="6" maxlength="4" value="<%=end_dt%>" class="text" >
	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  	<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name='s_kd'>
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
          <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>차대번호</option>		  
          <option value="4" <%if(s_kd.equals("4")){%>selected<%}%>>계약번호</option>		  
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
          <option value='5' <%if(s_kd.equals("5"))%>selected<%%>>사업자번호</option>
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
        <a href='javascript:search()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
        <a href='javascript:reg()'><img src=/acar/images/center/button_reg.gif align=right border=0></a> 
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="3%">연번</td>
                    <td class=title width="5%">보험</td>
                    <td class=title width="4%">구분</td>
                    <td class=title width="11%">계약번호</td>
                    <td class=title width="16%">상호</td>
                    <td class=title width="11%">사업자번호</td>
                    <td class=title width="8%">차량번호</td>
                    <td class=title width="15%">차대번호</td>			
                    <td class=title width="13%">증권번호</td>			
                    <td class=title width="17%">보험기간</td>
                    <td class=title width="5%"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                </tr>
              <%for (int i = 0 ; i < accid_size ; i++){
    			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><%=Util.subData(String.valueOf(accid.get("INS_COM_NM")), 3)%></td>
                    <td> 
                      <%if(accid.get("INS_STS").equals("1")&&accid.get("USE_YN").equals("Y")){%>
                    	  진행 
                      <%}else{%>
                     	  해지 
                      <%}%>
                    </td>
                    <td><%=accid.get("RENT_L_CD")%></td>
                    <td><%=accid.get("FIRM_NM")%></td>
                    <td><%=accid.get("ENP_NO")%></td>
                    <td><%=accid.get("CAR_NO")%></td>
                    <td><%=accid.get("CAR_NUM")%></td>			
                    <td><%=accid.get("INS_CON_NO")%></td>			
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("INS_EXP_DT")))%></td>
                    <td><input type="checkbox" name="chk" id="chk" value="<%=accid.get("CAR_MNG_ID")%>,<%=accid.get("INS_ST")%>,<%=accid.get("RENT_L_CD")%>"/></td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
