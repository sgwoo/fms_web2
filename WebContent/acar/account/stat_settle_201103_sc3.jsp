<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.estimate_mng.*, acar.settle_acc.*, acar.user_mng.*, acar.account.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "09", "05", "02");
	
	
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_settle");
	
	//계산식 변수
	String var3 = e_db.getEstiSikVarCase("1", "", "dly2_bus3");
	String var4 = e_db.getEstiSikVarCase("1", "", "dly2_bus4");
	String var5 = e_db.getEstiSikVarCase("1", "", "dly2_bus5");
	String var6 = e_db.getEstiSikVarCase("1", "", "dly2_bus6");
	String var7 = e_db.getEstiSikVarCase("1", "", "dly2_bus7");
	String var10 = e_db.getEstiSikVarCase("1", "", "dly2_bus10");
	String var11 = e_db.getEstiSikVarCase("1", "", "dly2_bus11");
	String var12 = e_db.getEstiSikVarCase("1", "", "dly2_bus12");
	
	
	//2군 채권관리캠페인 리스트
	Vector vt = st_db.getStatSettle("2", save_dt, var12, var7);
	int vt_size = vt.size();	
	
	String reg_dt		= "";
	if(vt_size>0){
		for(int i=0; i<1; i++){
			IncomingSBean feedp = (IncomingSBean)vt.elementAt(i);
			reg_dt			= feedp.getReg_dt();
		}
	}
	
	String tot_su3 = "";
	String tot_su6 = "";
	String tot_su7 = "";
	String tot_su8 = "";
	
	float dly_per1 = 0;
	float dly_per2 = 0;
	float per_0405 = 0;
	String per2 = "";
	float sum_tot_amt1 = 0, sum_tot_amt2 = 0 ;
	int sum_tot_amt3 = 0, sum_tot_amt4 = 0 ;
	int sum_tot_amt6 = 0, sum_tot_amt7 = 0 ;
	float a_per1 = 0;
	float a_avg_per = 0;
	float a_cmp_per = 0;
	float r_cmp_per = 0;
	int cnt = 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수금 스케줄 리스트 이동
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '7';
		fm.gubun2.value = '2';
		fm.gubun3.value = '5';	
		fm.gubun4.value = '';			
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/acar/settle_acc/settle_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}	
	
	function view_avg_per(bus_id2){
		window.open("stat_settle_view_avg_per.jsp?save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>&loan_st=1&bus_id2="+bus_id2,"VIEW_AVGPER","left=30,top=50,width=750,height=550,scrollbars=yes");	
	}			
	
	//당일마감
	function Magam(){
		var fm = document.form1;	
		fm.mode.value = '8';
		if(!confirm('마감하시겠습니까?'))
			return;
		fm.action = '/acar/admin/stat_end_null_200911.jsp';
		fm.submit();		
	}
	
	//변수수정		
	function OpenHelp(){
		var fm = document.form1;		
		var SUBWIN = "stat_dly_help3.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&save_dt="+fm.save_dt.value+"&from_page="+fm.from_page.value;
		window.open(SUBWIN, "Help", "left=100, top=100, width=650, height=400, scrollbars=yes");
	}
	
	
	//프린트하기
	function cmp_print(){
		window.open("stat_settle_sc3_print.jsp?save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//변수수정		
	function OpenEff(){
		var fm = document.form1;		
		var SUBWIN = "stat_settle_eff.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&loan_st=2&save_dt=<%=save_dt%>&max_amt=<%=var7%>";
		window.open(SUBWIN, "Eff", "left=100, top=100, width=650, height=600, scrollbars=yes");
	}
	
//-->
</script>
</head>

<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='from_page' value='/acar/account/stat_settle_201103_sc3.jsp'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>

<table width="<%if(s_width.equals("768")){%><%=AddUtil.parseInt(s_width)-100%><%}else{%>100%<%}%>" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>채권관리캠페인(2군)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr> 
        <td align="right"><img src=../images/center/arrow_gji.gif border=0 align=absmiddle> : <%=reg_dt%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' width="13%">총받을어음</td>
                    <td align="center" width="25%" valign="middle"><b><input type="text" name="sum_tot_amt1" class="whitenum">원</b>&nbsp;</td>
                    <td class='title' width="12%">연체금액</td>
                    <td align="center" width="25%"><b><font color='red'><input type="text" name="sum_tot_amt2" class="whitenum" >원</font></b>&nbsp;
        																<input type='hidden' name='tot_dly_amt' value=''></td>
                    <td class='title' width="10%">연체율</td>
                    <td align="center" width="15%"><b><font color='red'><input name="avg_tot_amt" type="text" class="whitenum" size="7">%</font></b>&nbsp;
        																<input type='hidden' name='tot_dly_per' value=''></td>
                </tr>
            </table>
        </td>
        <td width="20" bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사원별 미수금 현황 그래프</span>
		  &nbsp;<a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sub_item_list.jsp?gubun1=선수금','list_id3','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>		
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=3% rowspan="2" class="title">순위</td>				
                    <td width=7% rowspan="2" class="title">부서</td>									
                    <td width=8% rowspan="2" class="title">담당자</td>
                    <td width=9% rowspan="2" class="title">총받을어음</td>
                    <td width=10% rowspan="2" class="title">연체금액</td>										
                    <td width=5% rowspan="2" class="title">연체<br>점유비</td>																													
                    <td colspan="4" class="title">연체율</td>
                    <td width=14% rowspan="2" class="title">포상금액</td>
                    <td width=23% rowspan="2">
                      <table width=100% border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td class="title_p" style='text-align:right' width="25%">&nbsp;<br>1<br>&nbsp;</td>
                          <td class="title_p" style='text-align:right' width="25%">2</td>
                          <td class="title_p" style='text-align:right' width="25%">3</td>
                          <td class="title_p" style='text-align:right' width="25%">4</td>                          
                        </tr>
                      </table>
                    </td>
                </tr>
                <tr>
                  <td width=5% class="title">당일</td>
                  <td width=6% class="title">평균</td>
                  <td width=5% class="title">마감</td>
                  <td width=5% class="title">적용</td>
                </tr>
          		<%	if(vt_size > 0){
						
						for (int i = 0 ; i < vt_size ; i++){
							IncomingSBean feedp = (IncomingSBean)vt.elementAt(i);
							
						
							if(feedp.getTot_su6().equals("")) feedp.setTot_su7(feedp.getTot_su3());
												
							dly_per1 = AddUtil.parseFloat(feedp.getTot_su7())*100;
														
							if(dly_per1 >80) dly_per1=80;
							
							//합계
							sum_tot_amt1 += AddUtil.parseFloat(feedp.getTot_amt1());
							sum_tot_amt2 += AddUtil.parseFloat(feedp.getTot_amt2());
							sum_tot_amt3 += AddUtil.parseInt(feedp.getTot_amt4());
							sum_tot_amt4 += AddUtil.parseInt(feedp.getTot_amt5());
							sum_tot_amt6 += AddUtil.parseInt(feedp.getTot_amt6());
							sum_tot_amt7 += AddUtil.parseInt(feedp.getTot_amt7());
							
							//평균
							a_per1 		+= AddUtil.parseFloat(feedp.getTot_su3()==null?"0":feedp.getTot_su3());
							a_avg_per 	+= AddUtil.parseFloat(feedp.getTot_su6()==null?"0":feedp.getTot_su6());
							a_cmp_per 	+= AddUtil.parseFloat(feedp.getTot_su7()==null?"0":feedp.getTot_su7());
							r_cmp_per 	+= AddUtil.parseFloat(feedp.getTot_su8()==null?"0":feedp.getTot_su8());
							
							tot_su3 = feedp.getTot_su3();
							tot_su6 = feedp.getTot_su6();
							tot_su7 = feedp.getTot_su7();
							tot_su8 = feedp.getTot_su8();
			%>		
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=c_db.getNameById(feedp.getDept_id(), "DEPT")%></td>				  
                  <td align="center"><a href="javascript:list_move('<%=feedp.getGubun()%>');"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a></td>                  
                  <td align="right"><%=Util.parseDecimalLong(feedp.getTot_amt1())%></td>
                  <td align="right"><%=Util.parseDecimal(feedp.getTot_amt2())%>
					  <a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sub_list2.jsp?bus_id2=<%=feedp.getGubun()%>&r_dly_amt=<%=feedp.getTot_amt2()%>','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
  					  <a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sms_list.jsp?bus_id2=<%=feedp.getGubun()%>&partner_id=<%=feedp.getPartner_id()%>','list_id2','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0" alt="리스트보기"></a>				  
				  </td>			
		  <td align="right"><%=AddUtil.parseFloatCipher(feedp.getTot_su4(),3)%></td>				  	  
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su3,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su6,3)%><a href="javascript:view_avg_per('<%=feedp.getGubun()%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su7,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su8,3)%></td>
                  <td align="right"><%= AddUtil.parseDecimal(feedp.getTot_amt4()) %><%if(AddUtil.parseInt(feedp.getTot_amt6())>0){%><br><font color='red'><%= AddUtil.parseDecimal(feedp.getTot_amt6()) %></font><%}%></td>
                  <!--<td align="right"><%= AddUtil.parseDecimal(feedp.getTot_amt5()) %></td>-->
                  <td>
 				    <table width=100% border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td>
						<!-- <img src=../../images/result1.gif width=<%=Float.toString(dly_per1).substring(0,Float.toString(dly_per1).indexOf("."))%>% height=10> -->
						     <img src=../../images/result1.gif width=<%=dly_per1*4%>% height=10>
						    <!--
							<%if(AddUtil.parseFloat(feedp.getTot_su5())>0){%>&nbsp;&nbsp;<%}%>
							<%=feedp.getTot_su5()%>
							<%if(AddUtil.parseFloat(feedp.getTot_su5())>0){%>%<%}%>
							-->
					      </td>
                        </tr>
                      </table>
				  </td>
                </tr>
          		<%		}%>				

		  		  <!--신입직원중 채권캠페인 미적용자 (받을어음 부족) -->
		 		<%	Vector feedps2 = st_db.getStatFSettle("2", save_dt, var12, var7);
					int feedp_size2 = feedps2.size();
					cnt = vt_size;
					for (int i = 0 ; i < feedp_size2 ; i++){
						IncomingSBean feedp = (IncomingSBean)feedps2.elementAt(i);
						cnt++;
						
						dly_per1 = AddUtil.parseFloat(feedp.getTot_su7())*100;
						if(dly_per1 >80) dly_per1=80;
						
						tot_su3 = feedp.getTot_su3();
						tot_su6 = feedp.getTot_su6();
						tot_su7 = feedp.getTot_su7();
						tot_su8 = feedp.getTot_su8();
					%>
                <tr>
                  <td align="center"><%=cnt%></td>
                  <td align="center"><%=c_db.getNameById(feedp.getDept_id(), "DEPT")%></td>				  
                  <td align="center"><a href="javascript:list_move('<%=feedp.getGubun()%>');"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a></td>
                  <td align="right"><%=Util.parseDecimalLong(feedp.getTot_amt1())%></td>
                  <td align="right"><%=Util.parseDecimal(feedp.getTot_amt2())%>
					  <a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sub_list2.jsp?bus_id2=<%=feedp.getGubun()%>&r_dly_amt=<%=feedp.getTot_amt2()%>','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
  					  <a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sms_list.jsp?bus_id2=<%=feedp.getGubun()%>&partner_id=<%=feedp.getPartner_id()%>','list_id2','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0" alt="리스트보기"></a>				  
				  </td>				
				  <td align="right"><%=AddUtil.parseFloatCipher(feedp.getTot_su4(),3)%></td>				    
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su3,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su6,3)%><a href="javascript:view_avg_per('<%=feedp.getGubun()%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su7,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su8,3)%></td>
                  <td align="right"><%= AddUtil.parseDecimal(feedp.getTot_amt4()) %></td>
                  <td>&nbsp;미적용(<%if(feedp.getGubun().equals("000076")){%>장기휴가<%}else{%>받을어음 부족<%}%>)</td>	    
                </tr>							
          		<%		}%>	
          		
		  		  <!--에이전트 채권캠페인 미적용자 -->
		 		<%	Vector feedps3 = st_db.getStatAgentSettle("2", save_dt, var12, var7);
					int feedp_size3 = feedps3.size();
					
					
					
					cnt = vt_size+feedp_size2;
					
					for (int i = 0 ; i < feedp_size3 ; i++){
						IncomingSBean feedp = (IncomingSBean)feedps3.elementAt(i);
						cnt++;
						
						dly_per1 = AddUtil.parseFloat(feedp.getTot_su7())*100;
						if(dly_per1 >80) dly_per1=80;
						
						tot_su3 = feedp.getTot_su3();
						tot_su6 = feedp.getTot_su6();
						tot_su7 = feedp.getTot_su7();
						tot_su8 = feedp.getTot_su8();
					%>
                <tr>
                  <td align="center"><%=cnt%></td>
                  <td align="center">에이전트</td>				  
                  <td align="center"><a href="javascript:list_move('<%=feedp.getGubun()%>');"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a></td>
                  <td align="right"><%=Util.parseDecimalLong(feedp.getTot_amt1())%></td>
                  <td align="right"><%=Util.parseDecimal(feedp.getTot_amt2())%><!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
                  
					  <a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sub_list2.jsp?bus_id2=<%=feedp.getGubun()%>&r_dly_amt=<%=feedp.getTot_amt2()%>','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
  					  <a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sms_list.jsp?bus_id2=<%=feedp.getGubun()%>&partner_id=<%=feedp.getPartner_id()%>','list_id2','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0" alt="리스트보기"></a>				  
  		
				  </td>				
				  <td align="right"><%=AddUtil.parseFloatCipher(feedp.getTot_su4(),3)%></td>				    
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su3,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su6,3)%><a href="javascript:view_avg_per('<%=feedp.getGubun()%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su7,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su8,3)%></td>
                  <td align="right"><%= AddUtil.parseDecimal(feedp.getTot_amt4()) %></td>
                  <td>&nbsp;미적용(에이전트)</td>	    
                </tr>							
          		<%		}%>	
          		          				
									
                <tr>
                  <td colspan="5" align="center" class="title"></td>
                  <td class="title" style='text-align:right'>평균&nbsp;</td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(a_per1/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(a_avg_per/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(a_cmp_per/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(r_cmp_per/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_tot_amt3) %></td>
                  <td class="title" style='text-align:left'>&nbsp;미적용 제외</TD>
                </tr>	
          		<%	}%>									
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
        <td height="22"">&nbsp;&nbsp;<font color="#FF00FF">♣ 채권관리보너스 계산식 :</font>
	      <font color="#999999"> 
          (부서평균적용연체율<%= AddUtil.parseFloatCipher2(a_cmp_per/vt_size, 3) %>-개인적용연체율)*개인총받을어음/포상단가, 천원미만반올림
		  </font>
		  <br>
		  &nbsp;&nbsp;<font color="#FF00FF">♣ 포상단가 :</font>
		  <font color="#999999">부서가포상금액합계/(<%=var5%> - 평균연체율) x <%=Util.parseDecimal(var4)%>원</font>
		   &nbsp;&nbsp;<font color="#FF00FF">♣ 가포상금액  : </font>
		  <font color="#999999">(부서평균적용연체율-개인적용연체율)*개인총받을어음, 보너스대상자</font>
		  <br>
		  &nbsp;&nbsp;<font color="#FF00FF">♣ 채권관리보너스 지급기준일 : </font>
		  <font color="#999999"><%=AddUtil.ChangeDate2(var3)%></font>&nbsp;&nbsp;
		  <font color="#FF00FF">♣ 총받을어음 기준금액 : </font>
		  <font color="#999999"><%=AddUtil.parseDecimal2(var7)%>원</font>&nbsp;&nbsp;
		  <font color="#FF00FF">♣ 지급기준 연체율 : </font>
		  <font color="#999999">적용연체율 </font>
		  <br>
		  &nbsp;&nbsp;<font color="#FF00FF">♣ 연체율 : </font>
		  <font color="#999999">당일-당일연체율, 평균-채권시작일부터 전일까지의 평균연체율, 마감-당일7:평균3, 적용-채권마감일에 적용할 연체율(당일7:평균3,대차료경감분제외)</font>  
		  <br>
		  &nbsp;&nbsp;<font color=red>♣  <!--2005년9월1일부로과태료/면책금 5배 할증, -->
		                                 <!--2012년01월1일부로 과태료 5배 할증, 20131022 할증해제-->
		                                 <!--2008년12월17일부로휴/대차료 청구시:청구일부터 5일간 경감, 입금시:입금일부터 10일간 경감 적용 (평균연체율 적용),<br>
		                                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                                          휴/대차료 청구미입금시: 청구일2개월부터 1개월까지 청구금액 10%연체 적용</font> <br> -->
		                                 <!--2012년01월01일부로 2군--/대차료 입금시:입금일부터 1개월간 입금금액 25% 경감 (평균연체율 적용),<br>-->
		                                                          <!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
		                                         <!--                 &nbsp;&nbsp;&nbsp;&nbsp;
		                                                          휴/대차료 청구미입금시: 청구일 2개월부터 1달간 청구금액 5%연체 적용 (평균연체율 적용)</font> <br> -->
		                                                          &nbsp;&nbsp;		  
          <%if( auth_rw.equals("4") || auth_rw.equals("6")){%>
          <a href="javascript:OpenHelp()" title='변수수정'><img src=../images/center/button_modify_bs.gif align=absmiddle border=0></a>  
          <a href="javascript:Magam()" title='당일마감'><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>   
		  <%}%>		 
		  <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	      &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()' title='프린트하기'><img src=../images/center/button_print.gif align=absmiddle border=0></a>
		  <%}%>
        </td>				
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>현황 리스트</span></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td height="19"><iframe src="./stat_settle_sc_in_list2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>&from_page=/acar/account/stat_settle_201103_sc3.jsp" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	document.form1.sum_tot_amt1.value = '<%= AddUtil.parseDecimal(sum_tot_amt1) %>';
	document.form1.sum_tot_amt2.value = '<%= AddUtil.parseDecimal(sum_tot_amt2) %>';
	document.form1.avg_tot_amt.value  = '<%= AddUtil.parseFloatCipher2(sum_tot_amt2/sum_tot_amt1*100, 3) %>';

//-->
</script>
</body>
</html>

