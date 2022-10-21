<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vt = e_db.getEstimateShResCarList(gubun1, gubun2, gubun3, gubun4, s_dt, e_dt, s_kd, t_wd, esti_m, esti_m_dt, esti_m_s_dt, esti_m_e_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

	//내용보기
	function EstiDisp(est_id){	
		var fm = document.form1;
		var SUBWIN = '';
		SUBWIN="/acar/secondhand_hp/estimate.jsp?est_id="+est_id+"&acar_id=<%//=ck_acar_id%>";		
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");
	}
	
	//내용보기
	function EstiDisp2(est_id){	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.action = 'esti_info.jsp';
		fm.target = '_blank';
		fm.submit();
	}	
//-->
</script>
<script language='javascript'>
<!--
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
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="esti_mng_u.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>"> 
  <input type="hidden" name="esti_m" value="<%=esti_m%>"> 
  <input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>"> 
  <input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>"> 
  <input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">         
  <input type="hidden" name="est_id" value="">          
  <input type="hidden" name="est_gubun" value="sh">            
<table border=0 cellspacing=0 cellpadding=0 width=1360>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'> 
        <td width=480 class='line' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=30 class=title>연번</td>
                    <td width=100 class=title>견적번호</td>
                    <td width=110 class=title>대여상품</td>
                    <td width=60 class=title>대여기간</td>
                    <td width=90 class=title>견적일자</td>
                    <td width=90 class=title>차량번호</td>
                </tr>
            </table>
        </td>
        <td class='line' width=880>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=120 class=title>차종</td>
                    <td width=80 class=title>최초등록일</td>
                    <td width=70 class=title>배기량</td>
                    <td width=100 class=title>차량가격</td>
                    <td width=100 class=title>대여료공급가</td>			
                    <td width=90 class=title>1일요금</td>									
                    <td width=100 class=title>견적주행거리</td>										
                    <td width=120 class=title>전월대비증감KM</td>			
                    <td width=100 class=title>월평균주행거리</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td width=480 class='line' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width=30 align=center><%=i+1%></td>
                    <td width=100 align=center><a href="javascript:EstiDisp('<%=ht.get("EST_ID")%>')"><%=ht.get("EST_ID")%></a></td>
                    <td width=110 align=center><%=c_db.getNameByIdCode("0009", "", String.valueOf(ht.get("A_A")))%></td>
                    <td width=60 align=center><%=ht.get("A_B")%>개월</td>
                    <td width=90 align=center><%= AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT"))) %></td>
                    <td width=90 align=center><a href="javascript:EstiDisp2('<%=ht.get("EST_ID")%>')"><%=ht.get("CAR_NO")%></a></td>
                </tr>
                  <%}%>
				<tr>						
				    <td class='title' colspan='6'>&nbsp;</td>
				</tr>						  
            </table>
        </td>
        <td width=880 class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					String avg_dist = String.valueOf(ht.get("AVG_DIST"));
					if(avg_dist.equals("0")) avg_dist = String.valueOf(ht.get("AVG_DIST"));
					if(avg_dist.equals("0")) avg_dist = String.valueOf(ht.get("AVERAGE_DIST"));
					
					total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("DAY_S_AMT")));
					%>
                <tr> 
                    <td width=120 align=center><span title="<%=ht.get("CAR_NM")%>"><%=Util.subData(String.valueOf(ht.get("CAR_NM")),10)%></span></td>
                    <td width=80 align=center><%= AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT"))) %></td>										
                    <td width=70 align=center><%=ht.get("DPM")%>cc</td>					
                    <td width=100 align="right"><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%>원&nbsp;</td>
                    <td width=100 align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원&nbsp;</td>
                    <td width=90 align="right"><%=Util.parseDecimal(String.valueOf(ht.get("DAY_S_AMT")))%>원&nbsp;</td>					
                    <td width=100 align=right><%=Util.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%>km</td>															
                    <td width=120 align=right><%=Util.parseDecimal(String.valueOf(ht.get("LAST_MON_DIST")))%>km</td>															
                    <td width=100 align=right><%=Util.parseDecimal(avg_dist)%>km</td>																				
                </tr>
                <%}%>
				<tr>						
				    <td class='title' colspan='4'>&nbsp;</td>
				    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt1)%></td>		
				    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt2)%></td>		
				    <td class='title' colspan='3'>&nbsp;</td>											
				</tr>								
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
