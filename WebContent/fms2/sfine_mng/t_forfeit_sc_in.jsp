<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.car_sche.*"%>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"000155":request.getParameter("gubun1");

	String rent="";

	long t_cnt1 = 0;
	long t_cnt2 = 0;
	long cnt1 = 0;
	long cnt2 = 0;
	
	long t_cnt3 = 0;
	long t_cnt4 = 0;
	long cnt3 = 0;
	long cnt4 = 0;
	
	long pcnt = 0;
	long t_pcnt = 0;
	
	long ncnt = 0;
	long t_ncnt = 0;
	
	long total_amt = 0;
	
	long post_amt = 0;
	long post_amt_tot = 0;

	int su = 0;

	long t_cnt1_t = 0;
	long t_cnt2_t = 0;
	long t_pcnt_t = 0;
	long t_ncnt_t = 0;
	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	
	AddForfeitHanDatabase afm_db = AddForfeitHanDatabase.getInstance();
	
	Vector fines = new Vector();

	fines = afm_db.Moncount(user_id, gubun1, st_year, st_mon);
	
	int fine_size = fines.size();
	int reg_dt = 0;

	String whatday = "";	
	int day_of_week = 0;
	
		
	//월별 합계
	//수기등록
	long m_cnt1a = 0;
	long m_cnt2a = 0;
	long m_cnt3a = 0;
	long m_cnt4a = 0;
	long m_cnt5a = 0;
	long m_cnt6a = 0;
	long m_cnt7a = 0;
	long m_cnt8a = 0;
	long m_cnt9a = 0;
	long m_cnt10a = 0;
	long m_cnt11a = 0;
	long m_cnt12a = 0;
	
	long m_cnt1b = 0;
	long m_cnt2b = 0;
	long m_cnt3b = 0;
	long m_cnt4b = 0;
	long m_cnt5b = 0;
	long m_cnt6b = 0;
	long m_cnt7b = 0;
	long m_cnt8b = 0;
	long m_cnt9b = 0;
	long m_cnt10b = 0;
	long m_cnt11b = 0;
	long m_cnt12b = 0;
	
	long m_cnt1c = 0;
	long m_cnt2c = 0;
	long m_cnt3c = 0;
	long m_cnt4c = 0;
	long m_cnt5c = 0;
	long m_cnt6c = 0;
	long m_cnt7c = 0;
	long m_cnt8c = 0;
	long m_cnt9c = 0;
	long m_cnt10c = 0;
	long m_cnt11c = 0;
	long m_cnt12c = 0;
	
	long m_cnt1d = 0;
	long m_cnt2d = 0;
	long m_cnt3d = 0;
	long m_cnt4d = 0;
	long m_cnt5d = 0;
	long m_cnt6d = 0;
	long m_cnt7d = 0;
	long m_cnt8d = 0;
	long m_cnt9d = 0;
	long m_cnt10d = 0;
	long m_cnt11d = 0;
	long m_cnt12d = 0;
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//수정: 스캔 보기
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			
	
	/* Title 고정 */
	function setupEvents(){
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}
	
	//과태료리스트보기
	function view_list(reg_dt, gov_id, gubun1){
		var auth_rw = document.form1.auth_rw.value;
		window.open("t_forfeit_list.jsp?auth_rw="+auth_rw+"&gov_id="+gov_id+"&gubun1="+gubun1+"&dt="+reg_dt, "FINE_LIST", "left=10, top=10, width=1200, height=700 scrollbars=yes");
	}	
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
		//스캔등록
	function scan_reg(){
		window.open("po_excel.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>", "Excel", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:">

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td class=h>○ 과태료 등록일 기준 리스트 현황</td><!--, (비용계산 : 등록업무만 2012-05-28일 까지 등록건 250원, 출력하고 도장/봉투작업 2012-05-29일 등록부터 350원.) -->
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td rowspan="2" colspan="1" class='title' width="10%"><p align="center">일자</p></td>
					<td rowspan="1" colspan="2" class='title' width="20%"><p align="center">수기등록</p></td>
					<td rowspan="1" colspan="2" class='title' width="20%"><p align="center">도로공사</p></td>
					<td rowspan="1" colspan="2" class='title' width="20%"><p align="center">경찰서(파일업로드)<!--<a href="javascript:scan_reg();" class="btn" title=' 첨부'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></p>--></td>
					<td rowspan="2" colspan="1" class='title' width="15%"><p align="center">우편발송업무</td>
					<td rowspan="2" colspan="1" class='title' width="15%"><p align="center">합계<br>(수수료)</td>
				</tr>
				<tr>
					<td class='title' width="7%"><p align="center">건수</p></td>
					<td class='title' width="13%"><p align="center">수수료</p></td>
					<td class='title' width="7%"><p align="center">건수</p></td>
					<td class='title' width="13%"><p align="center">수수료</p></td>
					<td class='title' width="7%"><p align="center">건수</p></td>
					<td class='title' width="13%"><p align="center">수수료</p></td>
				</tr>
				<%if(!st_mon.equals("")){%>
				
				<%	for (int i = 0 ; i < fine_size ; i++){
						Hashtable fine = (Hashtable)fines.elementAt(i); 						
					        t_cnt2 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT2")));							
							cnt2 =  AddUtil.parseLong(String.valueOf(fine.get("CNT2")));
							//t_cnt2 = 0;
							//cnt2 = 0 ;
							t_pcnt +=  AddUtil.parseLong(String.valueOf(fine.get("CNT3")));							
							pcnt =  AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
							
							t_ncnt +=  AddUtil.parseLong(String.valueOf(fine.get("CNT4")));							
							ncnt =  AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
							
							if(AddUtil.parseInt(String.valueOf(fine.get("REG_DT"))) >= 20120529){
								t_cnt3 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								cnt1 =  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								su = 350;
							}else{
								t_cnt1 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								cnt1 =  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								su = 250;
							}
							
							t_cnt1_t = (t_cnt1*250) + (t_cnt3*350);
							
						String regdt = String.valueOf(fine.get("REG_DT"));
						
						if(!gubun1.equals("000155")){	
							regdt = "30000101";
						}
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						
						
						
							if(String.valueOf(ct.get("AMT")).equals("10000")){
								post_amt = 10000;
								post_amt_tot += 10000;
							}
						
						
						day_of_week = calendar.getDayOfWeek(AddUtil.parseInt(String.valueOf(fine.get("REG_DT")).substring(0, 4)), AddUtil.parseInt(String.valueOf(fine.get("REG_DT")).substring(4, 6)), AddUtil.parseInt(String.valueOf(fine.get("REG_DT")).substring(6, 8)));
						whatday = AddUtil.parseDateWeek("1", day_of_week);
				%>
				<tr>
					<td align="center" width=8%><%=String.valueOf(fine.get("REG_DT")).substring(4, 6)%>-<%=String.valueOf(fine.get("REG_DT")).substring(6, 8)%>(<%=whatday%>)</td>
					<td align="right"width=8%><a href="javascript:view_list('<%=fine.get("REG_DT")%>','','<%=gubun1%>')"><%=cnt1%></a> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(cnt1*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><a href="javascript:view_list('<%=fine.get("REG_DT")%>','278','<%=gubun1%>')"><%=AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")))%></a>&nbsp;
					<%if(user_id.equals("000096")){%>
					<a  href="javascript:MM_openBrWindow('fine_ex_cnt.jsp?user_id=<%=user_id%>','Fine_ex','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')">
					.</a>
					<%}%>
					건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal((ncnt+cnt2)*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><a href="javascript:view_list('<%=fine.get("REG_DT")%>','police','<%=gubun1%>')"><%=fine.get("CNT3")%></a> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(pcnt*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%if(String.valueOf(ct.get("AMT")).equals("10000")){%>10,000<%}else if(String.valueOf(fine.get("REG_DT")).equals("20140430")){%>10,000<%}else{%>0<%}%> 원 &nbsp;</td>
					<td align="right"width=8%><%if(String.valueOf(ct.get("AMT")).equals("10000")){%><%=AddUtil.parseDecimal((cnt1*350) + ((ncnt+cnt2)*150) + (pcnt*100))%><%}else{%><%=AddUtil.parseDecimal((cnt1*350) + ((ncnt+cnt2)*150) + (pcnt*100) + 0)%><%}%> 원</td>
				</tr>
				<%}%>
				
				
				<tr>
					<td class='title' colspan='1'>합계</td>
					<td class='' align="right"><%=AddUtil.parseDecimal(t_cnt1+t_cnt3)%> 건 &nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt1_t)%> 원 &nbsp;</td>
					<td class='' align="right"><%=AddUtil.parseDecimal(t_ncnt+t_cnt2)%>건&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((t_ncnt+t_cnt2)*150)%> 원 &nbsp;</td>
					<td class='' align="right"><%=AddUtil.parseDecimal(t_pcnt)%>건&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_pcnt*100)%> 원 &nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(post_amt_tot)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((t_cnt1_t+t_cnt2_t) + (t_pcnt*100)+ ((t_ncnt+t_cnt2)*150) + post_amt_tot)%> 원</td>
				</tr>
				<%}else{//월별 합계 구하기%>
				<%	for (int i = 0 ; i < fine_size ; i++){
						Hashtable fine = (Hashtable)fines.elementAt(i); 						

							if(AddUtil.parseInt(String.valueOf(fine.get("REG_DT"))) >= 20120529){
								t_cnt3 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								cnt1 =  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								su = 350;
							}else{
								t_cnt1 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								cnt1 =  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
								su = 250;
							}
							
	
						String regdt = "";
						
						
					if(	String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("01")){

						m_cnt1a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt1b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt1c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						
						regdt = String.valueOf(fine.get("REG_DT"));

						Hashtable ct = afm_db.getFineCardDoc(regdt);

						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt1d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("02")){
						m_cnt2a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt2b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt2c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						
						regdt = String.valueOf(fine.get("REG_DT"));

						Hashtable ct = afm_db.getFineCardDoc(regdt);

						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt2d += 10000;
						}
						
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("03")){
						m_cnt3a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt3b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt3c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt3d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("04")){
						m_cnt4a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt4b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt4c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt4d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("05")){
						m_cnt5a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt5b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt5c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt5d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("06")){
						m_cnt6a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt6b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt6c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt6d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("07")){
						m_cnt7a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt7b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt7c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt7d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("08")){
						m_cnt8a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt8b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt8c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt8d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("09")){
						m_cnt9a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt9b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt9c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt9d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("10")){
						m_cnt10a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt10b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt10c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt10d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("11")){
						m_cnt11a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt11b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt11c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt11d += 10000;
						}
					}else if(String.valueOf(fine.get("REG_DT")).substring(4, 6).equals("12")){
						m_cnt12a += AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						m_cnt12b += AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")));
						m_cnt12c += AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
						regdt = String.valueOf(fine.get("REG_DT"));
						Hashtable ct = afm_db.getFineCardDoc(regdt);
						if(String.valueOf(ct.get("AMT")).equals("10000")){
							m_cnt12d += 10000;
						}
					}
				%>
				<%}%>
				<tr>
					<td align="center" width=8%>1월</td>
					<td align="right"width=8%><%=m_cnt1a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt1a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt1b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt1b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt1c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt1c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt1d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt1a*su)+(m_cnt1b*150)+(m_cnt1c*100)+m_cnt1d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>2월</td>
					<td align="right"width=8%><%=m_cnt2a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt2a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt2b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt2b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt2c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt2c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt2d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt2a*su)+(m_cnt2b*150)+(m_cnt2c*100)+m_cnt2d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>3월</td>
					<td align="right"width=8%><%=m_cnt3a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt3a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt3b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt3b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt3c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt3c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt3d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt3a*su)+(m_cnt3b*150)+(m_cnt3c*100)+m_cnt3d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>4월</td>
					<td align="right"width=8%><%=m_cnt4a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt4a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt4b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt4b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt4c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt4c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt4d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt4a*su)+(m_cnt4b*150)+(m_cnt4c*100)+m_cnt4d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>5월</td>
					<td align="right"width=8%><%=m_cnt5a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt5a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt5b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt5b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt5c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt5c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt5d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt5a*su)+(m_cnt5b*150)+(m_cnt5c*100)+m_cnt5d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>6월</td>
					<td align="right"width=8%><%=m_cnt6a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt6a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt6b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt6b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt6c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt6c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt6d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt6a*su)+(m_cnt6b*150)+(m_cnt6c*100)+m_cnt6d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>7월</td>
					<td align="right"width=8%><%=m_cnt7a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt7a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt7b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt7b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt7c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt7c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt7d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt7a*su)+(m_cnt7b*150)+(m_cnt7c*100)+m_cnt7d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>8월</td>
					<td align="right"width=8%><%=m_cnt8a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt8a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt8b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt8b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt8c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt8c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt8d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt8a*su)+(m_cnt8b*150)+(m_cnt8c*100)+m_cnt8d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>9월</td>
					<td align="right"width=8%><%=m_cnt9a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt9a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt9b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt9b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt9c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt9c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt9d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt9a*su)+(m_cnt9b*150)+(m_cnt9c*100)+m_cnt9d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>10월</td>
					<td align="right"width=8%><%=m_cnt10a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt10a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt10b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt10b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt10c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt10c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt10d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt10a*su)+(m_cnt10b*150)+(m_cnt10c*100)+m_cnt10d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>11월</td>
					<td align="right"width=8%><%=m_cnt11a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt11a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt11b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt11b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt11c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt11c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt11d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt11a*su)+(m_cnt11b*150)+(m_cnt11c*100)+m_cnt11d)%> 원 &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>12월</td>
					<td align="right"width=8%><%=m_cnt12a%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt12a*su)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt12b%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt12b*150)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=m_cnt12c%> 건&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt12c*100)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt12d)%> 원 &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt12a*su)+(m_cnt12b*150)+(m_cnt12c*100)+m_cnt12d)%> 원 &nbsp;</td>
				</tr>

				<tr>
					<td class='title' colspan='1'>합계</td>
					<td class='' align="right"><%=m_cnt1a+m_cnt2a+m_cnt3a+m_cnt4a+m_cnt5a+m_cnt6a+m_cnt7a+m_cnt8a+m_cnt9a+m_cnt10a+m_cnt11a+m_cnt12a%> 건&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((m_cnt1a+m_cnt2a+m_cnt3a+m_cnt4a+m_cnt5a+m_cnt6a+m_cnt7a+m_cnt8a+m_cnt9a+m_cnt10a+m_cnt11a+m_cnt12a)*su)%> 원&nbsp;</td>
					<td class='' align="right"><%=m_cnt1b+m_cnt2b+m_cnt3b+m_cnt4b+m_cnt5b+m_cnt6b+m_cnt7b+m_cnt8b+m_cnt9b+m_cnt10b+m_cnt11b+m_cnt12b%> 건&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((m_cnt1b+m_cnt2b+m_cnt3b+m_cnt4b+m_cnt5b+m_cnt6b+m_cnt7b+m_cnt8b+m_cnt9b+m_cnt10b+m_cnt11b+m_cnt12b)*150)%> 원&nbsp;</td>
					<td class='' align="right"><%=m_cnt1c+m_cnt2c+m_cnt3c+m_cnt4c+m_cnt5c+m_cnt6c+m_cnt7c+m_cnt8c+m_cnt9c+m_cnt10c+m_cnt11c+m_cnt12c%> 건&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((m_cnt1c+m_cnt2c+m_cnt3c+m_cnt4c+m_cnt5c+m_cnt6c+m_cnt7c+m_cnt8c+m_cnt9c+m_cnt10c+m_cnt11c+m_cnt12c)*100)%> 원&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(m_cnt1d+m_cnt2d+m_cnt3d+m_cnt4d+m_cnt5d+m_cnt6d+m_cnt7d+m_cnt8d+m_cnt9d+m_cnt10d+m_cnt11d+m_cnt12d)%> 원&nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((((m_cnt1a+m_cnt2a+m_cnt3a+m_cnt4a+m_cnt5a+m_cnt6a+m_cnt7a+m_cnt8a+m_cnt9a+m_cnt10a+m_cnt11a+m_cnt12a)*su)+((m_cnt1b+m_cnt2b+m_cnt3b+m_cnt4b+m_cnt5b+m_cnt6b+m_cnt7b+m_cnt8b+m_cnt9b+m_cnt10b+m_cnt11b+m_cnt12b)*150)+((m_cnt1c+m_cnt2c+m_cnt3c+m_cnt4c+m_cnt5c+m_cnt6c+m_cnt7c+m_cnt8c+m_cnt9c+m_cnt10c+m_cnt11c+m_cnt12c)*100)+(m_cnt1d+m_cnt2d+m_cnt3d+m_cnt4d+m_cnt5d+m_cnt6d+m_cnt7d+m_cnt8d+m_cnt9d+m_cnt10d+m_cnt11d+m_cnt12d)))%>원&nbsp;</td>
				</tr>
				<%}%>
				
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td>○ 수수료 단가표 </td>
	</tr>	
	<tr>
		 <td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tbody>
					<tr>
						<td rowspan="1" colspan="2" class='title'><p>&nbsp;구    분</p></td>
						<td class='title'><p>수기등록&nbsp;</p></td>
						<td class='title'><p>도로공사</p></td>
						<td class='title'><p>경찰서(파일업로드)</p></td>
						<td class='title'><p>우편발송업무&nbsp;</p></td>
					</tr>
					<tr>
						<td rowspan="2" colspan="1" class='title'><p>&nbsp;단가</p></td>
						<td class='title'><p>금액&nbsp;</p></td>
						<td align="center"><p>&nbsp;350원</p></td>
						<td align="center"><p>&nbsp;150원</p></td>
						<td align="center"><p>&nbsp;100원</p></td>
						<td align="center"><p>&nbsp;10,000원</p></td>
					</tr>
					<tr>
						<td class='title'><p>&nbsp;기준일자</p></td>
						<td align="center"><p>&nbsp;2012-05-29</p></td>
						<td align="center"><p>&nbsp;2013-08-01</p></td>
						<td align="center"><p>&nbsp;2013-07-23</p></td>
						<td align="center"><p>&nbsp;2012-05-29</p></td>
					</tr>
					<tr>
						<td colspan="2" class='title'>기    타</td>
						<td colspan="4" >&nbsp;&nbsp;&nbsp;출력(인쇄)업무 포함</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
