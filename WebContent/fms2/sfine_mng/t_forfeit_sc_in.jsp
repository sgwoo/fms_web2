<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.car_sche.*"%>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
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
	
		
	//���� �հ�
	//������
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
	
	//����: ��ĵ ����
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			
	
	/* Title ���� */
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
	
	//���·Ḯ��Ʈ����
	function view_list(reg_dt, gov_id, gubun1){
		var auth_rw = document.form1.auth_rw.value;
		window.open("t_forfeit_list.jsp?auth_rw="+auth_rw+"&gov_id="+gov_id+"&gubun1="+gubun1+"&dt="+reg_dt, "FINE_LIST", "left=10, top=10, width=1200, height=700 scrollbars=yes");
	}	
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
		//��ĵ���
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
        <td class=h>�� ���·� ����� ���� ����Ʈ ��Ȳ</td><!--, (����� : ��Ͼ����� 2012-05-28�� ���� ��ϰ� 250��, ����ϰ� ����/�����۾� 2012-05-29�� ��Ϻ��� 350��.) -->
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td rowspan="2" colspan="1" class='title' width="10%"><p align="center">����</p></td>
					<td rowspan="1" colspan="2" class='title' width="20%"><p align="center">������</p></td>
					<td rowspan="1" colspan="2" class='title' width="20%"><p align="center">���ΰ���</p></td>
					<td rowspan="1" colspan="2" class='title' width="20%"><p align="center">������(���Ͼ��ε�)<!--<a href="javascript:scan_reg();" class="btn" title=' ÷��'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></p>--></td>
					<td rowspan="2" colspan="1" class='title' width="15%"><p align="center">����߼۾���</td>
					<td rowspan="2" colspan="1" class='title' width="15%"><p align="center">�հ�<br>(������)</td>
				</tr>
				<tr>
					<td class='title' width="7%"><p align="center">�Ǽ�</p></td>
					<td class='title' width="13%"><p align="center">������</p></td>
					<td class='title' width="7%"><p align="center">�Ǽ�</p></td>
					<td class='title' width="13%"><p align="center">������</p></td>
					<td class='title' width="7%"><p align="center">�Ǽ�</p></td>
					<td class='title' width="13%"><p align="center">������</p></td>
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
					<td align="right"width=8%><a href="javascript:view_list('<%=fine.get("REG_DT")%>','','<%=gubun1%>')"><%=cnt1%></a> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(cnt1*su)%> �� &nbsp;</td>
					<td align="right"width=8%><a href="javascript:view_list('<%=fine.get("REG_DT")%>','278','<%=gubun1%>')"><%=AddUtil.parseLong(String.valueOf(fine.get("CNT2")))+AddUtil.parseLong(String.valueOf(fine.get("CNT4")))%></a>&nbsp;
					<%if(user_id.equals("000096")){%>
					<a  href="javascript:MM_openBrWindow('fine_ex_cnt.jsp?user_id=<%=user_id%>','Fine_ex','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')">
					.</a>
					<%}%>
					��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal((ncnt+cnt2)*150)%> �� &nbsp;</td>
					<td align="right"width=8%><a href="javascript:view_list('<%=fine.get("REG_DT")%>','police','<%=gubun1%>')"><%=fine.get("CNT3")%></a> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(pcnt*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%if(String.valueOf(ct.get("AMT")).equals("10000")){%>10,000<%}else if(String.valueOf(fine.get("REG_DT")).equals("20140430")){%>10,000<%}else{%>0<%}%> �� &nbsp;</td>
					<td align="right"width=8%><%if(String.valueOf(ct.get("AMT")).equals("10000")){%><%=AddUtil.parseDecimal((cnt1*350) + ((ncnt+cnt2)*150) + (pcnt*100))%><%}else{%><%=AddUtil.parseDecimal((cnt1*350) + ((ncnt+cnt2)*150) + (pcnt*100) + 0)%><%}%> ��</td>
				</tr>
				<%}%>
				
				
				<tr>
					<td class='title' colspan='1'>�հ�</td>
					<td class='' align="right"><%=AddUtil.parseDecimal(t_cnt1+t_cnt3)%> �� &nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt1_t)%> �� &nbsp;</td>
					<td class='' align="right"><%=AddUtil.parseDecimal(t_ncnt+t_cnt2)%>��&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((t_ncnt+t_cnt2)*150)%> �� &nbsp;</td>
					<td class='' align="right"><%=AddUtil.parseDecimal(t_pcnt)%>��&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_pcnt*100)%> �� &nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(post_amt_tot)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((t_cnt1_t+t_cnt2_t) + (t_pcnt*100)+ ((t_ncnt+t_cnt2)*150) + post_amt_tot)%> ��</td>
				</tr>
				<%}else{//���� �հ� ���ϱ�%>
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
					<td align="center" width=8%>1��</td>
					<td align="right"width=8%><%=m_cnt1a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt1a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt1b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt1b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt1c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt1c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt1d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt1a*su)+(m_cnt1b*150)+(m_cnt1c*100)+m_cnt1d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>2��</td>
					<td align="right"width=8%><%=m_cnt2a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt2a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt2b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt2b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt2c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt2c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt2d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt2a*su)+(m_cnt2b*150)+(m_cnt2c*100)+m_cnt2d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>3��</td>
					<td align="right"width=8%><%=m_cnt3a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt3a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt3b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt3b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt3c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt3c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt3d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt3a*su)+(m_cnt3b*150)+(m_cnt3c*100)+m_cnt3d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>4��</td>
					<td align="right"width=8%><%=m_cnt4a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt4a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt4b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt4b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt4c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt4c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt4d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt4a*su)+(m_cnt4b*150)+(m_cnt4c*100)+m_cnt4d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>5��</td>
					<td align="right"width=8%><%=m_cnt5a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt5a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt5b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt5b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt5c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt5c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt5d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt5a*su)+(m_cnt5b*150)+(m_cnt5c*100)+m_cnt5d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>6��</td>
					<td align="right"width=8%><%=m_cnt6a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt6a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt6b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt6b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt6c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt6c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt6d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt6a*su)+(m_cnt6b*150)+(m_cnt6c*100)+m_cnt6d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>7��</td>
					<td align="right"width=8%><%=m_cnt7a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt7a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt7b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt7b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt7c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt7c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt7d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt7a*su)+(m_cnt7b*150)+(m_cnt7c*100)+m_cnt7d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>8��</td>
					<td align="right"width=8%><%=m_cnt8a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt8a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt8b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt8b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt8c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt8c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt8d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt8a*su)+(m_cnt8b*150)+(m_cnt8c*100)+m_cnt8d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>9��</td>
					<td align="right"width=8%><%=m_cnt9a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt9a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt9b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt9b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt9c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt9c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt9d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt9a*su)+(m_cnt9b*150)+(m_cnt9c*100)+m_cnt9d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>10��</td>
					<td align="right"width=8%><%=m_cnt10a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt10a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt10b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt10b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt10c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt10c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt10d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt10a*su)+(m_cnt10b*150)+(m_cnt10c*100)+m_cnt10d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>11��</td>
					<td align="right"width=8%><%=m_cnt11a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt11a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt11b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt11b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt11c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt11c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt11d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt11a*su)+(m_cnt11b*150)+(m_cnt11c*100)+m_cnt11d)%> �� &nbsp;</td>
				</tr>
				<tr>
					<td align="center" width=8%>12��</td>
					<td align="right"width=8%><%=m_cnt12a%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt12a*su)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt12b%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt12b*150)%> �� &nbsp;</td>
					<td align="right"width=8%><%=m_cnt12c%> ��&nbsp;</td>
					<td align="right"width=9%><%=AddUtil.parseDecimal(m_cnt12c*100)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal(m_cnt12d)%> �� &nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((m_cnt12a*su)+(m_cnt12b*150)+(m_cnt12c*100)+m_cnt12d)%> �� &nbsp;</td>
				</tr>

				<tr>
					<td class='title' colspan='1'>�հ�</td>
					<td class='' align="right"><%=m_cnt1a+m_cnt2a+m_cnt3a+m_cnt4a+m_cnt5a+m_cnt6a+m_cnt7a+m_cnt8a+m_cnt9a+m_cnt10a+m_cnt11a+m_cnt12a%> ��&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((m_cnt1a+m_cnt2a+m_cnt3a+m_cnt4a+m_cnt5a+m_cnt6a+m_cnt7a+m_cnt8a+m_cnt9a+m_cnt10a+m_cnt11a+m_cnt12a)*su)%> ��&nbsp;</td>
					<td class='' align="right"><%=m_cnt1b+m_cnt2b+m_cnt3b+m_cnt4b+m_cnt5b+m_cnt6b+m_cnt7b+m_cnt8b+m_cnt9b+m_cnt10b+m_cnt11b+m_cnt12b%> ��&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((m_cnt1b+m_cnt2b+m_cnt3b+m_cnt4b+m_cnt5b+m_cnt6b+m_cnt7b+m_cnt8b+m_cnt9b+m_cnt10b+m_cnt11b+m_cnt12b)*150)%> ��&nbsp;</td>
					<td class='' align="right"><%=m_cnt1c+m_cnt2c+m_cnt3c+m_cnt4c+m_cnt5c+m_cnt6c+m_cnt7c+m_cnt8c+m_cnt9c+m_cnt10c+m_cnt11c+m_cnt12c%> ��&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal((m_cnt1c+m_cnt2c+m_cnt3c+m_cnt4c+m_cnt5c+m_cnt6c+m_cnt7c+m_cnt8c+m_cnt9c+m_cnt10c+m_cnt11c+m_cnt12c)*100)%> ��&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(m_cnt1d+m_cnt2d+m_cnt3d+m_cnt4d+m_cnt5d+m_cnt6d+m_cnt7d+m_cnt8d+m_cnt9d+m_cnt10d+m_cnt11d+m_cnt12d)%> ��&nbsp;</td>
					<td align="right"width=8%><%=AddUtil.parseDecimal((((m_cnt1a+m_cnt2a+m_cnt3a+m_cnt4a+m_cnt5a+m_cnt6a+m_cnt7a+m_cnt8a+m_cnt9a+m_cnt10a+m_cnt11a+m_cnt12a)*su)+((m_cnt1b+m_cnt2b+m_cnt3b+m_cnt4b+m_cnt5b+m_cnt6b+m_cnt7b+m_cnt8b+m_cnt9b+m_cnt10b+m_cnt11b+m_cnt12b)*150)+((m_cnt1c+m_cnt2c+m_cnt3c+m_cnt4c+m_cnt5c+m_cnt6c+m_cnt7c+m_cnt8c+m_cnt9c+m_cnt10c+m_cnt11c+m_cnt12c)*100)+(m_cnt1d+m_cnt2d+m_cnt3d+m_cnt4d+m_cnt5d+m_cnt6d+m_cnt7d+m_cnt8d+m_cnt9d+m_cnt10d+m_cnt11d+m_cnt12d)))%>��&nbsp;</td>
				</tr>
				<%}%>
				
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td>�� ������ �ܰ�ǥ </td>
	</tr>	
	<tr>
		 <td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tbody>
					<tr>
						<td rowspan="1" colspan="2" class='title'><p>&nbsp;��    ��</p></td>
						<td class='title'><p>������&nbsp;</p></td>
						<td class='title'><p>���ΰ���</p></td>
						<td class='title'><p>������(���Ͼ��ε�)</p></td>
						<td class='title'><p>����߼۾���&nbsp;</p></td>
					</tr>
					<tr>
						<td rowspan="2" colspan="1" class='title'><p>&nbsp;�ܰ�</p></td>
						<td class='title'><p>�ݾ�&nbsp;</p></td>
						<td align="center"><p>&nbsp;350��</p></td>
						<td align="center"><p>&nbsp;150��</p></td>
						<td align="center"><p>&nbsp;100��</p></td>
						<td align="center"><p>&nbsp;10,000��</p></td>
					</tr>
					<tr>
						<td class='title'><p>&nbsp;��������</p></td>
						<td align="center"><p>&nbsp;2012-05-29</p></td>
						<td align="center"><p>&nbsp;2013-08-01</p></td>
						<td align="center"><p>&nbsp;2013-07-23</p></td>
						<td align="center"><p>&nbsp;2012-05-29</p></td>
					</tr>
					<tr>
						<td colspan="2" class='title'>��    Ÿ</td>
						<td colspan="4" >&nbsp;&nbsp;&nbsp;���(�μ�)���� ����</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
