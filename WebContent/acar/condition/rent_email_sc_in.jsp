<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm	 	= request.getParameter("g_fm")==null?"1":request.getParameter("g_fm");
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String sort 	= request.getParameter("sort")==null?gubun2:request.getParameter("sort");
	
	Vector cars = al_db.getClientMgrEmailStat(gubun2, dt);
	int car_size = cars.size();	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--

/* Title 고정 */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}

function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=680, height=600, resizable=yes");
}

//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post' target='d_content' action='/acar/car_rent/con_reg_frame.jsp'>
<table border=0 cellspacing=0 cellpadding=0 width="1480">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1480">
                <tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;'> 
            	  		<table border=0 cellspacing=1 width="280">
                            <tr> 
                                <td width=50 class=title style='height:51'>연번</td>
                                <td width=80 class=title>근무처</td>
                                <td width=70 class=title>부서</td>				
                                <td width=80 class=title><%if(gubun2.equals("1")){%>최초영업자 <%}else{%> 영업담당자 <%}%></td>
                            </tr>
                        </table>
		            </td>
		            <td class=line width=100%>
			            <table  border=0 cellspacing=1 width="1200">
                            <tr>
                                <td width=5% rowspan="2" class=title>계약건수</td>
                                <td width=5% rowspan="2" class=title>거래처수</td>
                                <td colspan="3" class=title>등록율</td>
                                <td colspan="3" class=title>차량이용자</td>
                                <td colspan="3" class=title>차량관리자</td>
                                <td colspan="3" class=title>회계관리자</td>
                                <td colspan="3" class=title>영업담당 영업사원</td>
                                <td colspan="3" class=title>출고담당 영업사원</td>
                            </tr>
                            <tr>
                                <td width=5% class=title>총대상</td>
                                <td width=5% class=title>등록</td>
                                <td width=5% class=title>%</td>
                                <td width=5% class=title>등록</td>
                                <td width=5% class=title>미등록</td>
                                <td width=5% class=title>수신거부</td>
                                <td width=5% class=title>등록</td>
                                <td width=5% class=title>미등록</td>
                                <td width=5% class=title>수신거부</td>
                                <td width=5% class=title>등록</td>
                                <td width=5% class=title>미등록</td>
                                <td width=5% class=title>수신거부</td>
                                <td width=5% class=title>등록</td>
                                <td width=5% class=title>미등록</td>
                                <td width=5% class=title>수신거부</td>
                                <td width=5% class=title>등록</td>
                                <td width=5% class=title>미등록</td>
                                <td width=5% class=title>수신거부</td>
                            </tr>
                        </table>
		            </td>
		        </tr>
<%	if(car_size != 0){ %>
                <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=280>
<%		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);%>
                            <tr> 
                                <td align="center" width=50><%= i+1%></td>
                                <td align="center" width=80><%=car.get("BR_NM")%></td>
                                <td align="center" width=70><%=car.get("DEPT_NM")%></td>
                                <td align="center" width=80><%=car.get("USER_NM")%></td>
                            </tr>
<%		}%>
                            <tr> 
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">&nbsp;</td>
                                <td class=title align="center">합계</td>
                            </tr>
                        </table>
		            </td>            		            		
                    <td class=line width=1200>
                        <table border=0 cellspacing=1 width=100%>
<%		int  t_cnt[] = new int[19];
		float per[] = new float[1];
		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			t_cnt[0] += AddUtil.parseInt(String.valueOf(car.get("CONT_CNT")));
			t_cnt[1] += AddUtil.parseInt(String.valueOf(car.get("CLIENT_CNT")));
			t_cnt[2] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_YY_CNT1")));
			t_cnt[3] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_YN_CNT1")));
			t_cnt[4] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_N_CNT1")));
			t_cnt[5] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_YY_CNT2")));
			t_cnt[6] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_YN_CNT2")));
			t_cnt[7] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_N_CNT2")));
			t_cnt[8] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_YY_CNT3")));
			t_cnt[9] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_YN_CNT3")));
			t_cnt[10] += AddUtil.parseInt(String.valueOf(car.get("MGR_E_N_CNT3")));
			t_cnt[11] += AddUtil.parseInt(String.valueOf(car.get("EMP_E_YY_CNT1")));
			t_cnt[12] += AddUtil.parseInt(String.valueOf(car.get("EMP_E_YN_CNT1")));
			t_cnt[13] += AddUtil.parseInt(String.valueOf(car.get("EMP_E_N_CNT1")));
			t_cnt[14] += AddUtil.parseInt(String.valueOf(car.get("EMP_E_YY_CNT2")));
			t_cnt[15] += AddUtil.parseInt(String.valueOf(car.get("EMP_E_YN_CNT2")));
			t_cnt[16] += AddUtil.parseInt(String.valueOf(car.get("EMP_E_N_CNT2")));
			t_cnt[17] += AddUtil.parseInt(String.valueOf(car.get("TOT_CNT")));
			t_cnt[18] += AddUtil.parseInt(String.valueOf(car.get("REG_CNT")));
			per[0] += AddUtil.parseFloat(String.valueOf(car.get("REG_PER")));
			%>
                            <tr> 
                                <td width=5% align="center"><%=car.get("CONT_CNT")%></td>
                                <td width=5% align="center"><%=car.get("CLIENT_CNT")%></td>
                                <td width=5% align="center"><a href="javascript:parent.view_cont('<%=car.get("USER_ID")%>','', '')"><%=car.get("TOT_CNT")%></a></td>
                                <td width=5% align="center"><%=car.get("REG_CNT")%></td>
                                <td width=5% align="center"><%=car.get("REG_PER")%>%</td>
                                <td width=5% align="center"><%=car.get("MGR_E_YY_CNT1")%></td>
                                <td width=5% align="center"><a href="javascript:parent.view_cont('<%=car.get("USER_ID")%>','차량이용자','2')"><%=car.get("MGR_E_YN_CNT1")%></a></td>
                                <td width=5% align="center"><%=car.get("MGR_E_N_CNT1")%></td>
                                <td width=5% align="center"><%=car.get("MGR_E_YY_CNT2")%></td>
                                <td width=5% align="center"><a href="javascript:parent.view_cont('<%=car.get("USER_ID")%>','차량관리자','2')"><%=car.get("MGR_E_YN_CNT2")%></a></td>
                                <td width=5% align="center"><%=car.get("MGR_E_N_CNT2")%></td>
                                <td width=5% align="center"><%=car.get("MGR_E_YY_CNT3")%></td>
                                <td width=5% align="center"><a href="javascript:parent.view_cont('<%=car.get("USER_ID")%>','회계관리자','2')"><%=car.get("MGR_E_YN_CNT3")%></a></td>
                                <td width=5% align="center"><%=car.get("MGR_E_N_CNT3")%></td>
                                <td width=5% align="center"><%=car.get("EMP_E_YY_CNT1")%></td>
                                <td width=5% align="center"><a href="javascript:parent.view_cont('<%=car.get("USER_ID")%>','영업담당자','2')"><%=car.get("EMP_E_YN_CNT1")%></a></td>
                                <td width=5% align="center"><%=car.get("EMP_E_N_CNT1")%></td>
                                <td width=5% align="center"><%=car.get("EMP_E_YY_CNT2")%></td>
                                <td width=5% align="center"><a href="javascript:parent.view_cont('<%=car.get("USER_ID")%>','출고담당자','2')"><%=car.get("EMP_E_YN_CNT2")%></a></td>
                                <td width=5% align="center"><%=car.get("EMP_E_N_CNT2")%></td>
                            </tr>
<%		}%>
                            <tr> 
                                <td class=title align="center"><%=t_cnt[0]%>건</td>
                                <td align="center" class=title><%=t_cnt[1]%>건</td>
                                <td align="center" class=title><%=t_cnt[17]%>건</td>
                                <td align="center" class=title><%=t_cnt[18]%>건</td>
                                <td align="center" class=title><%=Math.round(per[0]/car_size)%>%</td>
                                <td class=title align="center"><%=t_cnt[2]%>건</td>
                                <td class=title align="center"><%=t_cnt[3]%>건</td>
                                <td class=title align="center"><%=t_cnt[4]%>건</td>
                                <td class=title align="center"><%=t_cnt[5]%>건</td>
                                <td class=title align="center"><%=t_cnt[6]%>건</td>
                                <td class=title align="center"><%=t_cnt[7]%>건</td>
                                <td class=title align="center"><%=t_cnt[8]%>건</td>
                                <td class=title align="center"><%=t_cnt[9]%>건</td>
                                <td class=title align="center"><%=t_cnt[10]%>건</td>
                                <td class=title align="center"><%=t_cnt[11]%>건</td>												
                                <td class=title align="center"><%=t_cnt[12]%>건</td>
                                <td class=title align="center"><%=t_cnt[13]%>건</td>
                                <td class=title align="center"><%=t_cnt[14]%>건</td>
                                <td class=title align="center"><%=t_cnt[15]%>건</td>
                                <td class=title align="center"><%=t_cnt[16]%>건</td>				
                            </tr>
                        </table>
		            </td>            		            		
                </tr>
<%	}else{%>
	            <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=280>
                            <tr> 
                                <td align="center" width=100%></td>
                            </tr>
                        </table>
		            </td>            		            		
                    <td class=line width=1200>
                        <table border=0 cellspacing=1 width=100%>
    			            <tr>
    				            <td> &nbsp;등록된 데이타가 없습니다.</td>
    			            </tr>
    		            </table>
		            </td>            		            		
                </tr>
<%	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>