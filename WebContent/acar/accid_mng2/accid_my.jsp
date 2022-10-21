<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.target = 'd_content';
		fm.action = 'incoming.jsp';		
		fm.submit();	
	}

	//디스플레이 타입
	function cng_input(){
		var fm = document.form1;
		if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '1'){
			td_brch_id.style.display = '';
			td_bus_id2.style.display = 'none';
		}else if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '2'){
			td_brch_id.style.display = 'none';
			td_bus_id2.style.display = '';
		}else{
			td_brch_id.style.display = 'none';
			td_bus_id2.style.display = 'none';
		}
	}
	
	//사원별 연체관리현황
	function view_stat_dly(){
		var fm = document.form1;	
		fm.target = 'd_content';
//		fm.action = 'stat_dly_sc.jsp';
		fm.action = 'stat_settle_sc.jsp';
		fm.submit();	
	}	
	
	//수금 스케줄 리스트 이동
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;
		fm.gubun3.value = gubun3;	
		if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '1'){		//영업소				
			fm.s_kd.value = '6';		
			fm.t_wd.value = fm.brch_id.options[fm.brch_id.selectedIndex].value;
		}else if(fm.search_kd.options[fm.search_kd.selectedIndex].value == '2'){	//영업담당자			
			fm.s_kd.value = '8';		
			fm.t_wd.value = fm.bus_id2.options[fm.bus_id2.selectedIndex].value;			
		}else{
			fm.s_kd.value = '0';		
			fm.t_wd.value = '';					
		}
		var idx = gubun1;
		if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2'){
			url = "/fms2/con_grt/grt_frame_s.jsp";
			fm.gubun4.value = '';	
		}
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector ins_hs = ac_db.getInsHStat();
	
	int ins_h_size = ins_hs.size();
		
	long su[][]  = new long[12][3];
	long amt[][] = new long[12][3];
	
	
	
	
%>
<form name='form1' method='post' action='incoming.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보상금관리 > <span class=style5>휴/대차료 현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><div align="right"><img src=/acar/images/center/arrow_gjij.gif align=absmiddle> : <%= AddUtil.getDate()%> </td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
		<td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
				    <td colspan="4" rowspan="2" class='title'>구분</td>
				    <td colspan="2" class='title'>본점</td>
				    <td colspan="2" class='title'>부산지점</td>
				    <td colspan="2" class='title'>대전지점</td>
				    <td colspan="2" class='title'>합계</td>
				</tr>
               <tr>
			    <td width="9%" class='title'>건수</td>
			    <td width="9%" class='title'>금액</td>
			    <td width="9%" class='title'>건수</td>
			    <td width="9%" class='title'>금액</td>
			    <td width="9%" class='title'>건수</td>
			    <td width="9%" class='title'>금액</td>
			    <td width="9%" class='title'>건수</td>
			    <td width="9%" class='title'>금액</td>
			  </tr>
            </table>
		</td>
	</tr>
<%	if(ins_h_size > 0){
		for (int i = 0 ; i < ins_h_size ; i++){
			Hashtable ht = (Hashtable)ins_hs.elementAt(i);

			
			for(int j=0; j<3; j++){
					
					su[i][j]  = AddUtil.parseInt(String.valueOf(ht.get("TOT_SU"+j)));
					amt[i][j]  = AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT"+j)));
			}

       }   
   } 
%>
				
	<tr>
	    <td class=line>
	        <table width=100% border=0 cellspacing=1 cellpadding=0>
	            <tr>
                    <td width="8%" rowspan="8" class=title>
                      누<br>계<br>(사고발생일)</p>
                      </td>
                    <td width="7%" rowspan="4" class=title> 휴차료</td>
                    <td colspan="2" class=title>미청구</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[0][0]+su[6][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[0][0]+amt[6][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[0][1]+su[6][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[0][1]+amt[6][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[0][2]+su[6][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[0][2]+amt[6][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[0][0]+su[6][0]+su[0][1]+su[6][1]+su[0][2]+su[6][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[0][0]+amt[6][0]+amt[0][1]+amt[6][1]+amt[0][2]+amt[6][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td width="5%" rowspan="3" class=title>청구</td>
                    <td width="8%" class=title>수금</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[7][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[7][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][1]+su[7][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][1]+amt[7][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][2]+su[7][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][2]+amt[7][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[7][0]+su[1][1]+su[7][1]+su[1][2]+su[7][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[7][0]+amt[1][1]+amt[7][1]+amt[1][2]+amt[7][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>미수금</td>
                    <td align="right"><%=Util.parseDecimal(su[2][0]+su[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][0]+amt[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[2][1]+su[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][1]+amt[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[2][2]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][2]+amt[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[2][0]+su[8][0]+su[2][1]+su[8][1]+su[2][2]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][0]+amt[8][0]+amt[2][1]+amt[8][1]+amt[2][2]+amt[8][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[7][0]+su[2][0]+su[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[7][0]+amt[2][0]+amt[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][1]+su[7][1]+su[2][1]+su[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][1]+amt[7][1]+amt[2][1]+amt[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][2]+su[7][2]+su[2][2]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][2]+amt[7][2]+amt[2][2]+amt[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[7][0]+su[2][0]+su[8][0]+su[1][1]+su[7][1]+su[2][1]+su[8][1]+su[1][2]+su[7][2]+su[2][2]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[7][0]+amt[2][0]+amt[8][0]+amt[1][1]+amt[7][1]+amt[2][1]+amt[8][1]+amt[1][2]+amt[7][2]+amt[2][2]+amt[8][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="4" class=title>대차료</td>
                    <td colspan="2" class=title>미청구</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][0]+su[9][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][0]+amt[9][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][1]+su[9][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][1]+amt[9][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][2]+su[9][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][2]+amt[9][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][0]+su[9][0]+su[3][1]+su[9][1]+su[3][2]+su[9][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][0]+amt[9][0]+amt[3][1]+amt[9][1]+amt[3][2]+amt[9][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="3" class=title>청구</td>
                    <td class=title>수금</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[10][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[10][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][1]+su[10][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][1]+amt[10][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][2]+su[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][2]+amt[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[10][0]+su[4][1]+su[10][1]+su[4][2]+su[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[10][0]+amt[4][1]+amt[10][1]+amt[4][2]+amt[10][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>미수금</td>
                    <td align="right"><%=Util.parseDecimal(su[5][0]+su[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][0]+amt[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[5][1]+su[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][1]+amt[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[5][2]+su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][2]+amt[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[5][0]+su[11][0]+su[5][1]+su[11][1]+su[5][2]+su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][0]+amt[11][0]+amt[5][1]+amt[11][1]+amt[5][2]+amt[11][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[10][0]+su[5][0]+su[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[10][0]+amt[5][0]+amt[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][1]+su[10][1]+su[5][1]+su[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][1]+amt[10][1]+amt[5][1]+amt[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][2]+su[10][2]+su[5][2]+su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][2]+amt[10][2]+amt[5][2]+amt[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[10][0]+su[5][0]+su[11][0]+su[4][1]+su[10][1]+su[5][1]+su[11][1]+su[4][2]+su[10][2]+su[5][2]+su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[10][0]+amt[5][0]+amt[11][0]+amt[4][1]+amt[10][1]+amt[5][1]+amt[11][1]+amt[4][2]+amt[10][2]+amt[5][2]+amt[11][2])%>&nbsp;</td>
                </tr>

             
				 <tr>
                    <td rowspan="8" class=title>당월</td>
                    <td rowspan="4" class=title>휴차료</td>
                    <td colspan="2" class=title>미청구</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(su[0][0])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(amt[0][0])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(su[0][1])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(amt[0][1])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(su[0][2])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(amt[0][2])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(su[0][0]+su[0][1]+su[0][2])%>&nbsp;</td>
                    <td width="9%" align="right" class='is'><%=Util.parseDecimal(amt[0][0]+amt[0][1]+amt[0][2])%>&nbsp;</td>
                </tr>
                   
                <tr>
                    <td rowspan="3" class=title>청구</td>
                    <td class=title>수금</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[1][1]+su[1][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[1][1]+amt[1][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>미수금</td>
                    <td align="right"><%=Util.parseDecimal(su[2][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[2][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[2][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[2][0]+su[2][1]+su[2][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[2][0]+amt[2][1]+amt[2][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[2][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[2][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][1]+su[2][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][1]+amt[2][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][2]+su[2][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][2]+amt[2][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[1][0]+su[2][0]+su[1][1]+su[2][1]+su[1][2]+su[2][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[1][0]+amt[2][0]+amt[1][1]+amt[2][1]+amt[1][2]+amt[2][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="4" class=title>대차료</td>
                    <td colspan="2" class=title>미청구</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[3][0]+su[3][1]+su[3][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[3][0]+amt[3][1]+amt[3][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="3" class=title>청구</td>
                    <td class=title>수금</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[4][1]+su[4][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[4][1]+amt[4][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>미수금</td>
                    <td align="right"><%=Util.parseDecimal(su[5][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[5][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[5][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[5][0]+su[5][1]+su[5][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[5][0]+amt[5][1]+amt[5][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[5][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[5][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][1]+su[5][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][1]+amt[5][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][2]+su[5][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][2]+amt[5][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[4][0]+su[5][0]+su[4][1]+su[5][1]+su[4][2]+su[5][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[4][0]+amt[5][0]+amt[4][1]+amt[5][1]+amt[4][2]+amt[5][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="8" class=title>당월이전</td>
                    <td rowspan="4" class=title>휴차료</td>
                    <td colspan="2" class=title>미청구</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[6][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[6][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[6][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[6][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[6][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[6][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[6][0]+su[6][1]+su[6][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[6][0]+amt[6][1]+amt[6][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="3" class=title>청구</td>
                    <td class=title>수금</td>
                    <td align="right"><%=Util.parseDecimal(su[7][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[7][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[7][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[7][0]+su[7][1]+su[7][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][0]+amt[7][1]+amt[7][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>미수금</td>
                    <td align="right"><%=Util.parseDecimal(su[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[8][0]+su[8][1]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[8][0]+amt[8][1]+amt[8][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right"><%=Util.parseDecimal(su[7][0]+su[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][0]+amt[8][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[7][1]+su[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][1]+amt[8][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[7][2]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][2]+amt[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[7][0]+su[8][0]+su[7][1]+su[8][1]+su[7][2]+su[8][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[7][0]+amt[8][0]+amt[7][1]+amt[8][1]+amt[7][2]+amt[8][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="4" class=title>대차료</td>
                    <td colspan="2" class=title>미청구</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[9][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[9][0])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[9][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[9][1])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[9][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[9][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(su[9][0]+su[9][1]+su[9][2])%>&nbsp;</td>
                    <td align="right" class='is'><%=Util.parseDecimal(amt[9][0]+amt[9][1]+amt[9][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan="3" class=title>청구</td>
                    <td class=title>수금</td>
                    <td align="right"><%=Util.parseDecimal(su[10][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[10][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[10][0]+su[10][1]+su[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][0]+amt[10][1]+amt[10][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>미수금</td>
                    <td align="right"><%=Util.parseDecimal(su[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[11][0]+su[11][1]+su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[11][0]+amt[11][1]+amt[11][2])%>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="right"><%=Util.parseDecimal(su[10][0]+su[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][0]+amt[11][0])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[10][1]+su[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][1]+amt[11][1])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[10][2]+su[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][2]+amt[11][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(su[10][0]+su[11][0]+su[10][1]+su[11][1]+su[10][2]+su[10][2])%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(amt[10][0]+amt[11][0]+amt[10][1]+amt[11][1]+amt[10][2]+amt[11][2])%>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
   
	<tr>
        <td class=h></td>
    </tr>

</table>
</form>
</body>
</html>