<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String print_yn = request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt1 =0;
	int cnt2 =0;
	int cnt3 =0;
	int cnt4 =0;
	int cnt5 =0;
	int cnt6 =0;
	int cnt7 =0;
	int cnt8 =0;
	int cnt9 =0;
	int cnt10 =0;
	int cnt11 =0;
	int cnt12 =0;
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatSearchList(gubun1, "1");
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
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
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//프린트하기
	function stat_print(){
		window.open("ins_car_use_sc_in.jsp?gubun1=<%=gubun1%>&print_yn=Y","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}
	
	//엑셀
	function stat_excel(){
		window.open("ins_car_use_sc_in_excel.jsp?gubun1=<%=gubun1%>&print_yn=Y","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}

	//세부리스트
	function view_ins(gubun1, car_use, s_st, age_st, cnt){
		if(cnt==0){
			 alert('리스트가 없습니다.'); return;
		}else{
			window.open('view_ins_list.jsp?gubun1='+gubun1+'&car_use='+car_use+'&s_st='+s_st+'&age_st='+age_st, "STAT_INS_LIST", "left=0, top=0, width=1000, height=768, scrollbars=yes, status=yes, resize");
		}
	}
	
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%if(print_yn.equals("Y")){%>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<%}%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
<%if(print_yn.equals("Y")){%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>보험현황 > <span class=style5><%if(gubun1.equals("1")){%>영업용<%}else{%>업무용<%}%> 보험가입현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr><td class=h></td></tr>
     <tr>   
<%}%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>피보험자 아마존카</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='14%' class='title'>구분</td>
		    <td width='14%' class='title'>차종</td>
		    <td width='9%' class='title'>소분류순번</td>				
		    <td width='6%' class='title'>총건수</td>				
		    <td width='4%' class='title'>21세</td>				
		    <td width='4%' class='title'>22세</td>				
		    <td width='5%' class='title'>24세</td>				
		    <td width='5%' class='title'>26세</td>				
		    <td width='4%' class='title'>28세</td>				
		    <td width='4%' class='title'>30세</td>				
		    <td width='5%' class='title'>35세</td>				
		    <td width='6%' class='title'>35세~49세</td>				
		    <td width='4%' class='title'>43세</td>				
		    <td width='4%' class='title'>48세</td>				
		    <td width='5%' class='title'>모든연령</td>				
		    <td width='7%' class='title'>26세보험료</td>				
		</tr>    
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			cnt1 	= cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			cnt2 	= cnt2 + AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
			cnt3 	= cnt3 + AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
			cnt4 	= cnt4 + AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
			cnt5 	= cnt5 + AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
			cnt6 	= cnt6 + AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
			cnt7 	= cnt7 + AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
			cnt8 	= cnt8 + AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
			cnt9 	= cnt9 + AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
			cnt10 	= cnt10 + AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
			cnt11 	= cnt11 + AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
			cnt12 	= cnt12 + AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));

%>
				<tr>
					<td width='14%' align='center'><%=ht.get("GUBUN")%></td>
					<td width='14%' align='center'>
					    <%      if(String.valueOf(ht.get("GUBUN")).equals("승용소형A")){%>모닝,스파크
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용소형B")){%>아반떼,K3
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용중형")){%>쏘나타,K5
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용대형")){%>그랜저,K7
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 1600cc 이하")){%>QM3,티볼리
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 이하")){%>투싼,스포티지,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 이하")){%>싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("9인승")){%>카니발,코란도,투리스모
					    <%}else {%><%=ht.get("CAR")%>
					    <%}%>										
					</td>
					<td width='9%' align='center'><%=ht.get("S_ST_CD")%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_21_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','1','<%=ht.get("AGE_21_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_22_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','9','<%=ht.get("AGE_22_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>						
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_24_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','4','<%=ht.get("AGE_24_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_26_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','2','<%=ht.get("AGE_26_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_28_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','10','<%=ht.get("AGE_28_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_30_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','5','<%=ht.get("AGE_30_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_35_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','6','<%=ht.get("AGE_35_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_3549_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','11','<%=ht.get("AGE_3549_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_43_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','7','<%=ht.get("AGE_43_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_48_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','8','<%=ht.get("AGE_48_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_ETC_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','3','<%=ht.get("AGE_ETC_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='7%' align='right'><%=AddUtil.parseDecimal(ai_db.getInsureStatSearchListAmt(gubun1, "1", String.valueOf(ht.get("S_ST_CD")), "2"))%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt10)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt11)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt6)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt12)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt7)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt8)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt9)%></td>
                    <td class="title"></td>
                    
                </tr>	
			</table>
		</td>
    </tr>		
		
<%                     
	}                  
%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>피보험자 고객</span></td>
    </tr>
    
    
    <%		vt = ai_db.getInsureStatSearchList(gubun1, "2");
		vt_size = vt.size();
		cnt1 =0;
		cnt2 =0;
		cnt3 =0;
		cnt4 =0;
		cnt5 =0;
		cnt6 =0;
		cnt7 =0;
		cnt8 =0;
		cnt9 =0;
		cnt10 =0;
		cnt11 =0;
		cnt12 =0;
    %>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='14%' class='title'>구분</td>
		    <td width='14%' class='title'>차종</td>
		    <td width='9%' class='title'>소분류순번</td>				
		    <td width='6%' class='title'>총건수</td>				
		    <td width='4%' class='title'>21세</td>				
		    <td width='4%' class='title'>22세</td>				
		    <td width='5%' class='title'>24세</td>				
		    <td width='5%' class='title'>26세</td>				
		    <td width='4%' class='title'>28세</td>				
		    <td width='4%' class='title'>30세</td>				
		    <td width='5%' class='title'>35세</td>				
		    <td width='6%' class='title'>35세~49세</td>				
		    <td width='4%' class='title'>43세</td>				
		    <td width='4%' class='title'>48세</td>				
		    <td width='5%' class='title'>모든연령</td>				
		    <td width='7%' class='title'>보험료</td>				
		</tr>    
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		String max_cnt_age = "";
		String max_cnt_age_nm = "";
		int max_cnt = 0;
		
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			max_cnt = 0;
			max_cnt_age = "";
			max_cnt_age_nm = "";
			
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
				max_cnt_age = "1";
				max_cnt_age_nm = "21세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
				max_cnt_age = "9";
				max_cnt_age_nm = "22세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
				max_cnt_age = "4";
				max_cnt_age_nm = "24세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
				max_cnt_age = "2";
				max_cnt_age_nm = "26세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
				max_cnt_age = "10";
				max_cnt_age_nm = "28세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
				max_cnt_age = "5";
				max_cnt_age_nm = "30세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
				max_cnt_age = "6";
				max_cnt_age_nm = "35세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));
				max_cnt_age = "11";
				max_cnt_age_nm = "35~49세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
				max_cnt_age = "7";
				max_cnt_age_nm = "43세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
				max_cnt_age = "8";
				max_cnt_age_nm = "48세";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
				max_cnt_age = "3";
				max_cnt_age_nm = "모든연령";
			}
			
			
			cnt1 	= cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			cnt2 	= cnt2 + AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
			cnt3 	= cnt3 + AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
			cnt4 	= cnt4 + AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
			cnt5 	= cnt5 + AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
			cnt6 	= cnt6 + AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
			cnt7 	= cnt7 + AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
			cnt8 	= cnt8 + AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
			cnt9 	= cnt9 + AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
			cnt10 	= cnt10 + AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
			cnt11 	= cnt11 + AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
			cnt12 	= cnt12 + AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));


%>
				<tr>
					<td width='14%' align='center'><%=ht.get("GUBUN")%></td>
					<td width='14%' align='center'>
					    <%      if(String.valueOf(ht.get("GUBUN")).equals("승용소형A")){%>모닝,스파크
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용소형B")){%>아반떼,K3
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용중형")){%>쏘나타,K5
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용대형")){%>그랜저,K7
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 1600cc 이하")){%>QM3,티볼리
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 이하")){%>투싼,스포티지,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 이하")){%>싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("9인승")){%>카니발,코란도,투리스모
					    <%}else {%><%=ht.get("CAR")%>
					    <%}%>					
					</td>
					<td width='9%' align='center'><%=ht.get("S_ST_CD")%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_21_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','1','<%=ht.get("AGE_21_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_22_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','9','<%=ht.get("AGE_22_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_24_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','4','<%=ht.get("AGE_24_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_26_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','2','<%=ht.get("AGE_26_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_28_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','10','<%=ht.get("AGE_28_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_30_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','5','<%=ht.get("AGE_30_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_35_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','6','<%=ht.get("AGE_35_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_3549_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','11','<%=ht.get("AGE_3549_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_43_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','7','<%=ht.get("AGE_43_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_48_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','8','<%=ht.get("AGE_48_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_ETC_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','3','<%=ht.get("AGE_ETC_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a><%}%></td>
					<td width='7%' align='right'><%//=AddUtil.parseDecimal(String.valueOf(ht.get("G_2")))%>(<%=max_cnt_age_nm%>)<%=AddUtil.parseDecimal(ai_db.getInsureStatSearchListAmt(gubun1, "2", String.valueOf(ht.get("S_ST_CD")), max_cnt_age))%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt10)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt11)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt6)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt12)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt7)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt8)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt9)%></td>
                    <td class="title"></td>
                </tr>	
	    </table>
	</td>
    </tr>		
		
<%                     
	}                  
%>
    <%if(!print_yn.equals("Y")){%>
    </tr>
	<tr><td class=h></td></tr>
     <tr>       
    <tr>
        <td align='right'>
           <a href='javascript:stat_print()' title='프린트하기'><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a> 
           
           <a href='javascript:stat_excel()' title='프린트하기'><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
            </td>
    </tr>       
    <%}%>
</table>
<script language='javascript'>
<!--
<%if(print_yn.equals("Y")){%>
onprint();

function onprint(){
	factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= false; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
<%}%>	
//-->
</script>
</body>
</html>
