<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function move_page_amt(st, gubun, idx, idx2){
		var fm = document.form1;

		fm.gubun1.value = '';
		fm.gubun2.value = '';
		fm.gubun3.value = '';
		fm.gubun4.value = '';
		fm.gubun5.value = '';
		fm.gubun6.value = '';
		
		if(st == 2){//납입보험료
													fm.gubun4.value = '0';
			if(gubun == 'D'){						fm.gubun2.value = '1';				}
			else if(gubun == 'M'){					fm.gubun2.value = '2';				}
			else if(gubun == 'N'){					fm.gubun3.value = '2';				}
			if(idx == '2' && gubun != 'N'){			fm.gubun3.value = '1';				}
			else if(idx == '3' && gubun != 'N'){	fm.gubun3.value = '0';				}

			if(idx2 == '1'){						fm.gubun5.value = '1';				}
			else if(idx2 == '2'){					fm.gubun5.value = '2';				}
			else if(idx2 == '3'){					fm.gubun5.value = '3';				}

		}else if(st == 5){//보험료환급현황
													fm.gubun4.value = '2';		
			if(gubun == 'D'){						fm.gubun2.value = '1';				}
			else if(gubun == 'M'){					fm.gubun2.value = '2';				}
			else if(gubun == 'N'){					fm.gubun3.value = '2';				}
			if(idx == '2' && gubun != 'N'){			fm.gubun3.value = '1';				}
			else if(idx == '3' && gubun != 'N'){	fm.gubun3.value = '0';				}
		}
		fm.target = "d_content";		
		fm.action = "ins_s_frame.jsp";		
		fm.submit();
	}	

	function insDisp(m_id, l_cd, c_id, ins_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.cmd.value = "u";		
		fm.mode.value = "3";
		fm.action = "../ins_mng/ins_u_frame.jsp";
		fm.submit();
	}
	//출금
	function insScd(m_id, l_cd, c_id, ins_st, ins_tm){
//		window.open("ins_u_in4.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&ins_st="+ins_st+"&mode=cls", "INS_CLS", "left=100, top=100, width=650, height=300, scrollbars=yes");
		window.open("about:blank", "INS_CLS", "left=100, top=100, width=750, height=300, scrollbars=yes");
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.ins_tm.value = ins_tm;
		fm.mode.value = "pay";
		fm.action = "../ins_mng/ins_u_in3.jsp";		
		fm.target = "INS_CLS";
		fm.submit();		
	}		
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>

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
	
	InsDatabase ai_db = InsDatabase.getInstance();	
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='../ins_mng/ins_u_frame.jsp' method='post' target='d_content'>
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
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='ins_tm' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='go_url' value='../ins_mng2/ins_s_frame.jsp'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
   <tr> 
      <td colspan="6"><font color="navy">보험관리 -> </font><font color="red">납입예정보험료관리</font></td>
    </tr>
     <tr> 
      <td colspan="6">&nbsp;</td>
    </tr
    <tr> 
      <td colspan="2"><iframe src="ins_s_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun0=<%=gubun0%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&go_url=<%=go_url%>&s_st=<%=s_st%>#<%=idx%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
<!--    
  <tr>      		
    <td class='line'>
	<%if(!gubun4.equals("2")){%> 
    <%	Hashtable ins3 = ai_db.getInsStat2(1);%>
    <%	Hashtable ins4 = ai_db.getInsStat2(2);%>	
      <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" rowspan="2" colspan="2">구분</td>
            <td class='title' align="center" colspan="2" height="19">당월</td>
            <td class='title' align="center" colspan="2" height="19">당일</td>
            <td class='title' align="center" colspan="2" height="19">기일경과</td>
            <td colspan="2" class='title' align="center" height="19">합계(당일+기일경과)</td>
          </tr>
          <tr align="center"> 
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
          </tr>
          <tr align="center"> 
            <td class='title' rowspan="3" width="80">계획</td>
            <td class='title' width="80" height="18">신차</td>
            <td height="18"><a href="javascript:move_page_amt(2,'M',1,1)"><%=Util.parseInt(String.valueOf(ins3.get("MC1")))+Util.parseInt(String.valueOf(ins3.get("MC4")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("MA1")))+Util.parseInt(String.valueOf(ins3.get("MA4"))))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'D',1,1)"><%=Util.parseInt(String.valueOf(ins3.get("DC1")))+Util.parseInt(String.valueOf(ins3.get("DC4")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA1")))+Util.parseInt(String.valueOf(ins3.get("DA4"))))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'N',1,1)"><%=Util.parseInt(String.valueOf(ins4.get("NC1")))+Util.parseInt(String.valueOf(ins4.get("NC4")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins4.get("NA1")))+Util.parseInt(String.valueOf(ins4.get("NA4"))))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC1")))+Util.parseInt(String.valueOf(ins3.get("DC4")))+Util.parseInt(String.valueOf(ins4.get("NC1")))+Util.parseInt(String.valueOf(ins4.get("NC4")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA1")))+Util.parseInt(String.valueOf(ins3.get("DA4")))+Util.parseInt(String.valueOf(ins4.get("NA1")))+Util.parseInt(String.valueOf(ins4.get("NA4"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>용도변경</td>
            <td height="18"><a href="javascript:move_page_amt(2,'M',1,2)"><%=Util.parseInt(String.valueOf(ins3.get("MC2")))+Util.parseInt(String.valueOf(ins3.get("MC5")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("MA2")))+Util.parseInt(String.valueOf(ins3.get("MA5"))))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'D',1,2)"><%=Util.parseInt(String.valueOf(ins3.get("DC2")))+Util.parseInt(String.valueOf(ins3.get("DC5")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA2")))+Util.parseInt(String.valueOf(ins3.get("DA5"))))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'N',1,2)"><%=Util.parseInt(String.valueOf(ins4.get("NC2")))+Util.parseInt(String.valueOf(ins4.get("NC5")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins4.get("NA2")))+Util.parseInt(String.valueOf(ins4.get("NA5"))))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC2")))+Util.parseInt(String.valueOf(ins3.get("DC5")))+Util.parseInt(String.valueOf(ins4.get("NC2")))+Util.parseInt(String.valueOf(ins4.get("NC5")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA2")))+Util.parseInt(String.valueOf(ins3.get("DA5")))+Util.parseInt(String.valueOf(ins4.get("NA2")))+Util.parseInt(String.valueOf(ins4.get("NA5"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>갱신</td>
            <td height="18"><a href="javascript:move_page_amt(2,'M',1,3)"><%=Util.parseInt(String.valueOf(ins3.get("MC3")))+Util.parseInt(String.valueOf(ins3.get("MC6")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("MA3")))+Util.parseInt(String.valueOf(ins3.get("MA6"))))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'D',1,3)"><%=Util.parseInt(String.valueOf(ins3.get("DC3")))+Util.parseInt(String.valueOf(ins3.get("DC6")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA3")))+Util.parseInt(String.valueOf(ins3.get("DA6"))))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'N',1,3)"><%=Util.parseInt(String.valueOf(ins4.get("NC3")))+Util.parseInt(String.valueOf(ins4.get("NC6")))%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins4.get("NA3")))+Util.parseInt(String.valueOf(ins4.get("NA6"))))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC3")))+Util.parseInt(String.valueOf(ins3.get("DC6")))+Util.parseInt(String.valueOf(ins4.get("NC3")))+Util.parseInt(String.valueOf(ins4.get("NC6")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA3")))+Util.parseInt(String.valueOf(ins3.get("DA6")))+Util.parseInt(String.valueOf(ins4.get("NA3")))+Util.parseInt(String.valueOf(ins4.get("NA6"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title' rowspan="3">지출</td>
            <td class='title'>신차</td>
            <td height="18"><a href="javascript:move_page_amt(2,'M',2,1)"><%=ins3.get("MC1")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA1")))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'D',2,1)"><%=ins3.get("DC1")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA1")))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(2,'N',2,1)"><%=ins4.get("NC1")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA1")))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC1")))+Util.parseInt(String.valueOf(ins4.get("NC1")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA1")))+Util.parseInt(String.valueOf(ins4.get("NA1"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>용도변경</td>
            <td><a href="javascript:move_page_amt(2,'M',2,2)"><%=ins3.get("MC2")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA2")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'D',2,2)"><%=ins3.get("DC2")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA2")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'N',2,2)"><%=ins4.get("NC2")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA2")))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC2")))+Util.parseInt(String.valueOf(ins4.get("NC2")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA2")))+Util.parseInt(String.valueOf(ins4.get("NA2"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>갱신</td>
            <td><a href="javascript:move_page_amt(2,'M',2,3)"><%=ins3.get("MC3")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA3")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'D',2,3)"><%=ins3.get("DC3")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA3")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'N',2,3)"><%=ins4.get("NC3")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA3")))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC3")))+Util.parseInt(String.valueOf(ins4.get("NC3")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA3")))+Util.parseInt(String.valueOf(ins4.get("NA3"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title' rowspan="3">잔액</td>
            <td class='title'>신차</td>
            <td><a href="javascript:move_page_amt(2,'M',3,1)"><%=ins3.get("MC4")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA4")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'D',3,1)"><%=ins3.get("DC4")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA4")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'N',3,1)"><%=ins4.get("NC4")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA4")))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC4")))+Util.parseInt(String.valueOf(ins4.get("NC4")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA4")))+Util.parseInt(String.valueOf(ins4.get("NA4"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>용도변경</td>
            <td><a href="javascript:move_page_amt(2,'M',3,2)"><%=ins3.get("MC5")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA5")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'D',3,2)"><%=ins3.get("DC5")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA5")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'N',3,2)"><%=ins4.get("NC5")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA5")))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC5")))+Util.parseInt(String.valueOf(ins4.get("NC5")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA5")))+Util.parseInt(String.valueOf(ins4.get("NA5"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>갱신</td>
            <td><a href="javascript:move_page_amt(2,'M',3,3)"><%=ins3.get("MC6")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("MA6")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'D',3,3)"><%=ins3.get("DC6")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins3.get("DA6")))%>원</td>
            <td><a href="javascript:move_page_amt(2,'N',3,3)"><%=ins4.get("NC6")%>건</a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ins4.get("NA6")))%>원</td>
            <td height="18"><%=Util.parseInt(String.valueOf(ins3.get("DC6")))+Util.parseInt(String.valueOf(ins4.get("NC6")))%>건</td>
            <td height="18" align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins3.get("DA6")))+Util.parseInt(String.valueOf(ins4.get("NA6"))))%>원</td>
          </tr>
        </table>
	<%}else{%> 
    <%	Hashtable ins8 = ai_db.getInsStat5(1);%>
    <%	Hashtable ins9 = ai_db.getInsStat5(2);%>
    <%	Hashtable ins10 = ai_db.getInsStat5(3);%>			
        <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" rowspan="2">구분</td>
            <td class='title' align="center" colspan="2" height="19">당월</td>
            <td class='title' align="center" colspan="2" height="19">당일</td>
            <td class='title' align="center" colspan="2" height="19">연체</td>
            <td colspan="2" class='title' align="center" height="19">합계(당일+연체)</td>
          </tr>
          <tr align="center"> 
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
            <td class='title' width="60">건수</td>
            <td class='title' width="100">금액</td>
          </tr>
          <tr align="center"> 
            <td class='title' width="160">계획</td>
            <td><a href="javascript:move_page_amt(5,'M',1,0)"><%=Util.parseInt(String.valueOf(ins8.get("MC1")))+Util.parseInt(String.valueOf(ins8.get("MC2")))%>건</a></td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins8.get("MA1")))+Util.parseInt(String.valueOf(ins8.get("MA2"))))%>원</td>
            <td><a href="javascript:move_page_amt(5,'D',1,0)"><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins9.get("DC2")))%>건</a></td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins9.get("DA2"))))%>원</td>
            <td><a href="javascript:move_page_amt(5,'N',1,0)"><%=Util.parseInt(String.valueOf(ins10.get("NC1")))+Util.parseInt(String.valueOf(ins10.get("NC2")))%>건</a></td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins10.get("NA1")))+Util.parseInt(String.valueOf(ins10.get("NA2"))))%>원</td>
            <td><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins9.get("DC2")))+Util.parseInt(String.valueOf(ins10.get("NC1")))+Util.parseInt(String.valueOf(ins10.get("NC2")))%>건</td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins9.get("DA2")))+Util.parseInt(String.valueOf(ins10.get("NA1")))+Util.parseInt(String.valueOf(ins10.get("NA2"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>수금</td>
            <td height="18"><a href="javascript:move_page_amt(5,'M',2,0)"><%=ins8.get("MC1")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins8.get("MA1")))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(5,'D',2,0)"><%=ins9.get("DC1")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins9.get("DA1")))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(5,'N',2,0)"><%=ins10.get("NC1")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins10.get("NA1")))%>원</td>
            <td><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins10.get("NC1")))%>건</td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins10.get("NA1"))))%>원</td>
          </tr>
          <tr align="center"> 
            <td class='title'>미수금</td>
            <td height="18"><a href="javascript:move_page_amt(5,'M',3,0)"><%=ins8.get("MC2")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins8.get("MA2")))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(5,'D',3,0)"><%=ins9.get("DC2")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins9.get("DA2")))%>원</td>
            <td height="18"><a href="javascript:move_page_amt(5,'N',3,0)"><%=ins10.get("NC2")%>건</a></td>
            <td height="18" align="right"><%=Util.parseDecimal(String.valueOf(ins10.get("NA2")))%>원</td>
            <td><%=Util.parseInt(String.valueOf(ins9.get("DC1")))+Util.parseInt(String.valueOf(ins10.get("NC2")))%>건</td>
            <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ins9.get("DA1")))+Util.parseInt(String.valueOf(ins10.get("NA2"))))%>원</td>
          </tr>
        </table>
	<%}%> 				
      </td>
	<td width="20"></td>
  </tr>		
-->  
  </table>
</form>
</body>
</html>
