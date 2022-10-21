<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*, acar.settle_acc.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_settle");
	
	
	//영업사원 채권관리캠페인 리스트
	Vector vt = st_db.getStatSettleEmp(save_dt);
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
	
	
	
	String var7 = e_db.getEstiSikVarCase("1", "", "dly2_bus7");
	String var12 = e_db.getEstiSikVarCase("1", "", "dly2_bus12");
		
	//2군 채권관리캠페인 리스트
	Vector vt2 = st_db.getStatSettle("2", save_dt, var12, var7);
	int vt_size2 = vt2.size();	
	
	float sum_tot_amt1_2 = 0;
	float sum_tot_amt2_2 = 0;	
	
	if(vt_size2 > 0){						
		for (int i = 0 ; i < vt_size2 ; i++){
			IncomingSBean feedp = (IncomingSBean)vt2.elementAt(i);
			//합계
			sum_tot_amt1_2 += AddUtil.parseFloat(feedp.getTot_amt1());
			sum_tot_amt2_2 += AddUtil.parseFloat(feedp.getTot_amt2());
		}
	}
							
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
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
<input type='hidden' name='from_page' value='/agent/account/stat_settle_201103_sc4.jsp'>
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
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 캠페인관리 > <span class=style5>채권관리캠페인</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr> 
        <td align="right"><img src=/acar/images/center/arrow_gji.gif border=0 align=absmiddle> : <%=reg_dt%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' width="20%">아마존카 영업팀</td>
                    <td class='title' width="10%" rowspan='2'>총받을어음</td>
                    <td align="center" width="20%" valign="middle"><b><input type="text" name="sum_tot_amt1_2" class="whitenum">원</b></td>
                    <td class='title' width="10%" rowspan='2'>연체금액</td>
                    <td align="center" width="20%"><b><font color='red'><input type="text" name="sum_tot_amt2_2" class="whitenum" >원</font></b></td>
                    <td class='title' width="10%" rowspan='2'>연체율</td>
                    <td align="center" width="10%"><b><font color='red'><input name="avg_tot_amt_2" type="text" class="whitenum" size="7">%</font></b></td>
                </tr>            
                <tr> 
                    <td class='title' width="20%">에이젼트 및 10대이상 영업사원</td>                    
                    <td align="center" width="20%" valign="middle"><b><input type="text" name="sum_tot_amt1" class="whitenum">원</b></td>                    
                    <td align="center" width="20%"><b><font color='red'><input type="text" name="sum_tot_amt2" class="whitenum" >원</font></b><input type='hidden' name='tot_dly_amt' value=''></td>                    
                    <td align="center" width="10%"><b><font color='red'><input name="avg_tot_amt" type="text" class="whitenum" size="7">%</font></b><input type='hidden' name='tot_dly_per' value=''></td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미수금 현황 그래프</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=3% rowspan="2" class="title">순위</td>				
                    <td width=7% rowspan="2" class="title">구분</td>									
                    <td width=10% rowspan="2" class="title">소속</td>									
                    <td width=7% rowspan="2" class="title">성명</td>
                    <td width=10% rowspan="2" class="title">총받을어음</td>
                    <td width=8% rowspan="2" class="title">연체금액</td>										
                    <td width=5% rowspan="2" class="title">연체<br>점유비</td>																													
                    <td colspan="4" class="title">연체율</td>
                    <!--<td width=10% rowspan="2" class="title">포상금액</td>-->
                    <td width=30% rowspan="2">
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
                  <td width=5% class="title">평균</td>
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
                  <td align="center"><%=feedp.getBr_id()%></td>				  
                  <td align="center"><%if(user_bean.getSa_code().equals(feedp.getGubun())){%><%=feedp.getDept_id()%><%}else{%>************<%}%></td>				  
                  <td align="center"><%if(user_bean.getSa_code().equals(feedp.getGubun())){%><%=c_db.getNameById(feedp.getGubun(), "CAR_OFF_EMP")%><%}else{%>*****<%}%></td>                  
                  <td align="right"><%=Util.parseDecimalLong(feedp.getTot_amt1())%></td>
                  <td align="right"><%if(user_bean.getSa_code().equals(feedp.getGubun())){%><a href="javascript:MM_openBrWindow('stat_settle_sc_in_view_sub_list3.jsp?bus_id2=<%=feedp.getGubun()%>&r_dly_amt=<%=feedp.getTot_amt2()%>','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/acar/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>&nbsp;<%}%><%=Util.parseDecimal(feedp.getTot_amt2())%></td>			
		          <td align="right"><%=AddUtil.parseFloatCipher(feedp.getTot_su4(),3)%></td>				  	  
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su3,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su6,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su7,3)%></td>
                  <td align="right"><%=AddUtil.parseFloatCipher(tot_su8,3)%></td>
                  <td>
                      <%if(feedp.getBr_id().equals("에이전트")){%>
 				    <table width=100% border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td>
						    <img src=/acar/images/result1.gif width=<%=Float.toString(dly_per1).substring(0,Float.toString(dly_per1).indexOf("."))%>% height=10>
						   
					      </td>
                        </tr>
                      </table>
                      <%}else{%>
                      &nbsp;미적용(영업사원)
                      <%}%>                      

				  </td>
                </tr>
          		<%		}%>				
									
                <tr>
                  <td colspan="6" align="center" class="title"></td>
                  <td class="title" style='text-align:right'>평균&nbsp;</td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(a_per1/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(a_avg_per/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(a_cmp_per/vt_size, 3) %></td>
                  <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher2(r_cmp_per/vt_size, 3) %></td>                  
                  <td class="title" style='text-align:left'></TD>
                </tr>	

          		<%	}%>									
            </table>
        </td>
    </tr>
    <tr> 
        <td height="22"">&nbsp;&nbsp;    
            ※ 총받을어음 기준: 대여개시 12개월 이내
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	document.form1.sum_tot_amt1.value = '<%= AddUtil.parseDecimal(sum_tot_amt1) %>';
	document.form1.sum_tot_amt2.value = '<%= AddUtil.parseDecimal(sum_tot_amt2) %>';
	document.form1.avg_tot_amt.value  = '<%= AddUtil.parseFloatCipher2(sum_tot_amt2/sum_tot_amt1*100, 3) %>';

	document.form1.sum_tot_amt1_2.value = '<%= AddUtil.parseDecimal(sum_tot_amt1_2) %>';
	document.form1.sum_tot_amt2_2.value = '<%= AddUtil.parseDecimal(sum_tot_amt2_2) %>';
	document.form1.avg_tot_amt_2.value  = '<%= AddUtil.parseFloatCipher2(sum_tot_amt2_2/sum_tot_amt1_2*100, 3) %>';

//-->
</script>
</body>
</html>

