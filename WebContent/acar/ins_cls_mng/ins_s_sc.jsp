<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function move_page_mng(st, gubun, idx){
		var fm = document.form1;

		fm.gubun1.value = '';
		fm.gubun2.value = '';
		fm.gubun3.value = '';
		fm.gubun4.value = '';
		fm.gubun5.value = '';
		fm.gubun6.value = '';
		
		if(st == 1){//보험가입현황
			if(gubun == 'N'){			
											fm.gubun2.value = '5';
											fm.gubun3.value = '5';
				if     (idx   ==  1 ){		fm.gubun4.value = '1';									}
				else if(idx   ==  2 ){		fm.gubun4.value = '2';									}
				else if(idx   ==  3 ){		fm.gubun4.value = '3';									}
			}else{
				if(gubun == 'D'){			fm.gubun2.value = '1';									}
				else if(gubun == 'M'){		fm.gubun2.value = '2';									}
				if     (idx   ==  1 ){		fm.gubun3.value = '1';	fm.gubun4.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun3.value = '1';	fm.gubun4.value = '2';			}
				else if(idx   ==  3 ){		fm.gubun3.value = '2';									}
			}
		}else if(st == 3){//보험사항변경현황
			if(gubun == 'D'){				fm.gubun2.value = '1';									}
			else if(gubun == 'M'){			fm.gubun2.value = '2';									}
											fm.gubun3.value = '3';
			if     (idx   ==  1 ){			fm.gubun4.value = '1';									}
			else if(idx   ==  2 ){			fm.gubun4.value = '2';									}
			else if(idx   ==  3 ){			fm.gubun4.value = '3';									}
			else if(idx   ==  4 ){			fm.gubun4.value = '4';									}
			else if(idx   ==  5 ){			fm.gubun4.value = '5';									}
		}else if(st == 4){//보험해지현황
			if(gubun == 'N'){	
											fm.gubun2.value = '5';					
											fm.gubun3.value = '6';
				if     (idx   ==  1 ){		fm.gubun1.value = '1';	fm.gubun5.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun1.value = '2';	fm.gubun5.value = '1';			}
			}else{			
				if(gubun == 'D'){			fm.gubun2.value = '1';									}
				else if(gubun == 'M'){		fm.gubun2.value = '2';									}
											fm.gubun3.value = '3';									
				if     (idx   ==  1 ){		fm.gubun1.value = '1';	fm.gubun5.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun1.value = '2';	fm.gubun5.value = '1';			}
				else if(idx   ==  3 ){		fm.gubun1.value = '2';	fm.gubun5.value = '3';			}
				else if(idx   ==  4 ){		fm.gubun1.value = '2';	fm.gubun5.value = '2';			}				
			}

		}		
		fm.target.value = "d_content";			
		fm.action = "ins_s_frame.jsp";		
		fm.submit();
	}
	
	function insDisp(c_id, ins_st, ins_stat){
		var fm = document.form1;
		if(ins_stat == '미가입'){		alert('보험 미가입 상태입니다.'); return;	}
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.cmd.value = "u";		
		fm.target.value = "d_content";
		fm.action = "../ins_mng/ins_u_frame.jsp";
		fm.submit();
	}
	//해지
	function insCls(m_id, l_cd, c_id, ins_st){
//		window.open("ins_u_in4.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&ins_st="+ins_st+"&mode=cls", "INS_CLS", "left=100, top=100, width=650, height=300, scrollbars=yes");
		window.open("about:blank", "INS_CLS", "left=100, top=100, width=650, height=300, scrollbars=yes");
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.mode.value = "cls";
		fm.action = "../ins_mng/ins_u_in4.jsp";		
		fm.target = "INS_CLS";
		fm.submit();		
	}		
	function insHis(c_id)
	{
		window.open("ins_history.jsp?c_id="+c_id, "INS_HIS", "left=100, top=100, width=850, height=500, scrollbars=yes");
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
function select_cls_ins_excel_com(){
	var fm = parent.c_foot.i_no.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;
			}
		}
	}
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	fm.action = "ins_s_sc_excel_ins_com.jsp";
	fm.target = "_blank";
	fm.submit();
}	
	
-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>


<form name='form1' action='ins_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="go_url" value='../ins_mng/ins_s_frame.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
 <tr>
   			<td style="text-align:right;">
   				<%if(gubun2.equals("2")){%>
   				<%	if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>		
   				&nbsp;&nbsp;
		      <input type="button" class="button" value='보험 해지 요청 등록' onclick='javascript:select_cls_ins_excel_com();'>
		      <%	}%>
		      <%}%>
		      
   			</td>
    </tr>  	
    <tr> 
      <td colspan="2"><iframe src="ins_s_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun0=<%=gubun0%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&go_url=<%=go_url%>&s_st=<%=s_st%>#<%=idx%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
<!--    
    <%	Hashtable ins1 = ai_db.getInsClsStat(1);%>
    <%	Hashtable ins2 = ai_db.getInsClsStat(2);%>	
    <tr> 
      <td class="line"> 
        <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr align="center"> 
            <td class='title' align="center" rowspan="2" width="100">구분</td>
            <td class='title' colspan="3">청구구분</td>
            <td class='title' colspan="6">수금구분</td>
          </tr>
          <tr align="center"> 
            <td class='title' width="100">청구</td>
            <td class='title' width="100">미청구</td>
            <td class='title' width="100">계</td>
            <td class='title' colspan="2">수금</td>
            <td class='title' colspan="2">미수금</td>
            <td class='title' colspan="2">계</td>
          </tr>
          <tr align="center"> 
            <td class='title'>용도변경</td>
            <td><%=ins1.get("C1")%>건</td>
            <td><%=ins1.get("C2")%>건</td>
            <td><%=Util.parseInt(String.valueOf(ins1.get("C1")))+Util.parseInt(String.valueOf(ins1.get("C2")))%>건</td>
            <td width="50"><%=ins1.get("C3")%>건</td>
            <td align="right" width="80"><%=Util.parseDecimal(String.valueOf(ins1.get("A1")))%>원</td>
            <td width="50"><%=ins1.get("C4")%>건</td>
            <td align="right" width="80"><%=Util.parseDecimal(String.valueOf(ins1.get("A2")))%>원</td>
            <td width="55"><%=Util.parseInt(String.valueOf(ins1.get("C3")))+Util.parseInt(String.valueOf(ins1.get("C4")))%>건</td>
            <td align="right" width="85"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins1.get("A1")))+Util.parseInt(String.valueOf(ins1.get("A2"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>매각</td>
            <td><%=ins2.get("C1")%>건</td>
            <td><%=ins2.get("C2")%>건</td>
            <td><%=Util.parseInt(String.valueOf(ins2.get("C1")))+Util.parseInt(String.valueOf(ins2.get("C2")))%>건</td>
            <td width="50"><%=ins2.get("C3")%>건</td>
            <td align="right" width="80"><%=Util.parseDecimal(String.valueOf(ins2.get("A1")))%>원</td>
            <td width="50"><%=ins2.get("C4")%>건</td>
            <td align="right" width="80"><%=Util.parseDecimal(String.valueOf(ins2.get("A2")))%>원</td>
            <td width="55"><%=Util.parseInt(String.valueOf(ins2.get("C3")))+Util.parseInt(String.valueOf(ins2.get("C4")))%>건</td>
            <td align="right" width="85"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins2.get("A1")))+Util.parseInt(String.valueOf(ins2.get("A2"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>합계</td>
            <td><%=Util.parseInt(String.valueOf(ins1.get("C1")))+Util.parseInt(String.valueOf(ins2.get("C1")))%>건</td>
            <td align="center"><%=Util.parseInt(String.valueOf(ins1.get("C2")))+Util.parseInt(String.valueOf(ins2.get("C2")))%>건</td>
            <td><%=Util.parseInt(String.valueOf(ins1.get("C1")))+Util.parseInt(String.valueOf(ins1.get("C2")))+Util.parseInt(String.valueOf(ins2.get("C1")))+Util.parseInt(String.valueOf(ins2.get("C2")))%>건</td>
            <td><%=Util.parseInt(String.valueOf(ins1.get("C3")))+Util.parseInt(String.valueOf(ins2.get("C3")))%>건</td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins1.get("A1")))+Util.parseInt(String.valueOf(ins2.get("A1"))))%>원</td>
            <td><%=Util.parseInt(String.valueOf(ins1.get("C4")))+Util.parseInt(String.valueOf(ins2.get("C4")))%>건</td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins1.get("A2")))+Util.parseInt(String.valueOf(ins2.get("A2"))))%>원</td>
            <td><%=Util.parseInt(String.valueOf(ins1.get("C3")))+Util.parseInt(String.valueOf(ins2.get("C3")))+Util.parseInt(String.valueOf(ins1.get("C4")))+Util.parseInt(String.valueOf(ins2.get("C4")))%>건</td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins1.get("A1")))+Util.parseInt(String.valueOf(ins1.get("A2")))+Util.parseInt(String.valueOf(ins1.get("A1")))+Util.parseInt(String.valueOf(ins1.get("A2"))))%>원</td>
          </tr>
        </table>
      </td>
      <td width="20"></td>
    </tr>
-->    
  </table>
</form>
</body>
</html>
