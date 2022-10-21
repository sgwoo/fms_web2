<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.insur.*"%>
<%@ page import="acar.mng_exp.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//기간비용
	function view_precost(cost_ym, cost_st){
		window.open('view_precost_exp_list.jsp?cost_ym='+cost_ym+'&cost_st='+cost_st, "PRECOST_LIST", "left=0, top=0, width=800, height=768, scrollbars=yes, status=yes, resize");
	}
	//자동차세스케줄
	function view_exp_scd(cost_ym, pay_yn, car_ext){
		window.open('view_exp_scd_list.jsp?cost_ym='+cost_ym+'&pay_yn='+pay_yn+'&car_ext='+car_ext, "EXP_SCD_LIST", "left=0, top=0, width=1050, height=768, scrollbars=yes, status=yes, resize");		
	}
	//미등록자동차세
	function view_exp_est(car_ext, gubun1, car_use){
		window.open('view_exp_est_list.jsp?car_ext='+car_ext+'&gubun1='+gubun1+'&car_use='+car_use, "EXP_EST_LIST", "left=0, top=0, width=1050, height=768, scrollbars=yes, status=yes, resize");		
	}
	//당원예상자동차세
	function view_exp_est_mon(car_use){
		window.open('view_exp_est_mon_list.jsp?car_use='+car_use, "EXP_EST_MON_LIST", "left=0, top=0, width=1050, height=768, scrollbars=yes, status=yes, resize");				
	}
	//전체-환급신청서
	function exp_rtn_req_a(car_ext){
		window.open('view_exp_rtn_doc_a.jsp?car_ext='+car_ext, "EXP_RTN_DOC", "left=0, top=0, width=900, height=700, scrollbars=yes, status=yes, resize");		
	}
	//신청-환급신청서
	function exp_rtn_req_s(car_ext){
		window.open('view_exp_rtn_doc_s.jsp?car_ext='+car_ext, "EXP_RTN_DOC", "left=0, top=0, width=900, height=700, scrollbars=yes, status=yes, resize");		
	}
	//미신청-환급신청서
	function exp_rtn_req(car_ext){
		window.open('view_exp_rtn_doc.jsp?car_ext='+car_ext, "EXP_RTN_DOC", "left=0, top=0, width=900, height=700, scrollbars=yes, status=yes, resize");		
	}
	//등록 자동차세 점검
	function exp_reg_check(car_ext, cost_ym){
		window.open('view_exp_reg_check.jsp?gubun1='+cost_ym+'&car_ext='+car_ext+'&mode=Y', "EXP_CHECK", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resize");			
	}	
	//미등록 자동차세 점검
	function exp_non_check(car_ext, cost_ym){
		window.open('view_exp_reg_check.jsp?gubun1='+cost_ym+'&car_ext='+car_ext+'&mode=N', "EXP_CHECK", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resize");			
	}	
	//환급미처리분
	function exp_rtn_reg(){
		window.open('precost_exp_stat_sc_rtn_null.jsp', "EXP_RTN", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resize");				
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//기간비용
	Vector costs = new Vector();
	int cost_size = 0;	
	
	//납부자동차세
	Vector scds = ai_db.getExpScdPayAmtStat(brch_id, gubun1);
	int scd_size = scds.size();
	
	//납부예정자동차세
	Vector scds2 = ai_db.getExpScdEstAmtStat(brch_id);
	int scd_size2 = scds2.size();
	
	//미등록 자동차세
	Vector scds3 = ai_db.getExpScdNonRegStat(brch_id, gubun1, "stat", "");
	int scd_size3 = scds3.size();
	
	//미수환급 자동차세
	Vector scds4 = ai_db.getExpRtnScdEstAmtStat(brch_id);
	int scd_size4 = scds4.size();
	
	//당월예상 자동차세
	Vector scds5 = ai_db.getExpScdMonEstStat();
	int scd_size5 = scds5.size();
	
	int sum1 = 0;
	int sum2 = 0;
	int sum3 = 0;
	int sum4 = 0;
%>
<form name='form1' action='' method='post' target='d_content'>
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
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='tot_su' value=''>
<input type='hidden' name='go_url' value='../ins_stat/ins_s4_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
<!--
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기간비용</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan="2" class='title'>년월</td>
                    <td class='title' colspan="2">합계</td>
                    <td class='title' colspan="2">영업용</td>
                    <td class='title' colspan="2">업무용</td>
                </tr>
                <tr>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                </tr>
                <%	for(int i = 0 ; i < cost_size ; i++){
					Hashtable ht = (Hashtable)costs.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("YM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%>건&nbsp;&nbsp;</td>
                    <td align="right"><a href="javascript:view_precost('<%=ht.get("YM")%>','1')"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%>원</a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>원&nbsp;&nbsp;</td>
                </tr>
<%			
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("AMT2")));
}%>			  
                <tr> 
                    <td align="center">계</td>
                    <td align="right"><%=Util.parseDecimal(sum1+sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2+sum4)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum1)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum4)%>원&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
-->    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납부자동차세</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan="2" class='title'>년월</td>
                    <td class='title' colspan="2">합계</td>
                    <td class='title' colspan="2">영업용</td>
                    <td class='title' colspan="2">업무용</td>
                </tr>
                <tr>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                </tr>
          <%	
		  		sum1 = 0;
				sum2 = 0;
				sum3 = 0;
				sum4 = 0;
			  	for(int i = 0 ; i < scd_size ; i++){
					Hashtable ht = (Hashtable)scds.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("YM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%>건&nbsp;&nbsp;</td>
                    <td align="right"><a href="javascript:view_exp_scd('<%=ht.get("YM")%>','1','')"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%>원</a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>원&nbsp;&nbsp;</td>
                </tr>
<%			
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("AMT2")));
}%>			  
                <tr> 
                    <td align="center">계</td>
                    <td align="right"><%=Util.parseDecimal(sum1+sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2+sum4)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum1)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum4)%>원&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납자동차세 <font color="#CCCCCC">: 고지서 접수 등록분</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan="2" class='title'>지역</td>
                    <td class='title' colspan="2">합계</td>
                    <td class='title' colspan="2">영업용</td>
                    <td class='title' colspan="2">업무용</td>
                </tr>
                <tr>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                </tr>
          <%	
		  		sum1 = 0;
				sum2 = 0;
				sum3 = 0;
				sum4 = 0;
			  	for(int i = 0 ; i < scd_size2 ; i++){
					Hashtable ht = (Hashtable)scds2.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("CAR_EXT_NM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%>건<a href="javascript:exp_reg_check('<%=ht.get("CAR_EXT")%>','<%=gubun1%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="자동차세점검"></a>&nbsp;&nbsp;</td>
                    <td align="right"><a href="javascript:view_exp_scd('<%=gubun1%>','0','<%=ht.get("CAR_EXT")%>')"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%>원</a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>원&nbsp;&nbsp;</td>
                </tr>
<%			
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("AMT2")));
}%>			  
                <tr> 
                    <td align="center">계</td>
                    <td align="right"><%=Util.parseDecimal(sum1+sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2+sum4)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum1)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum4)%>원&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미등록자동차세 <font color="#CCCCCC">: 고지서 미접수</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan="2" class='title'>지역</td>
                    <td class='title' colspan="2">합계</td>
                    <td class='title' colspan="2">영업용</td>
                    <td class='title' colspan="2">업무용</td>
                </tr>
                <tr>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                </tr>
          <%	
		  		sum1 = 0;
				sum2 = 0;
				sum3 = 0;
				sum4 = 0;
			  	for(int i = 0 ; i < scd_size3 ; i++){
					Hashtable ht = (Hashtable)scds3.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("CAR_EXT_NM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%>건<a href="javascript:exp_non_check('<%=ht.get("CAR_EXT")%>','<%=gubun1%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="자동차세점검"></a>&nbsp;&nbsp;</td>
                    <td align="right"><a href="javascript:view_exp_est('<%=ht.get("CAR_EXT")%>', '<%=gubun1%>','')"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%>원</a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><a href="javascript:view_exp_est('<%=ht.get("CAR_EXT")%>', '<%=gubun1%>','1')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>원</a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><a href="javascript:view_exp_est('<%=ht.get("CAR_EXT")%>', '<%=gubun1%>','2')"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>원</a>&nbsp;&nbsp;</td>
                </tr>
<%			
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("AMT2")));
}%>			  
                <tr> 
                    <td align="center">계</td>
                    <td align="right"><%=Util.parseDecimal(sum1+sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2+sum4)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum1)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum4)%>원&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미수환급자동차세</span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan="2" class='title'>지역</td>
                    <td class='title' colspan="2">합계</td>
                    <td class='title' colspan="2">신청</td>
                    <td class='title' colspan="2"><a href="javascript:exp_rtn_reg();">미신청</a></td>
                </tr>
                <tr>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                </tr>
          <%	
		  		sum1 = 0;
				sum2 = 0;
				sum3 = 0;
				sum4 = 0;
			  	for(int i = 0 ; i < scd_size4 ; i++){
					Hashtable ht = (Hashtable)scds4.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("CAR_EXT_NM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%>건<a href="javascript:exp_rtn_req_a('<%=ht.get("CAR_EXT")%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="환급신청서"></a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%>원&nbsp;&nbsp;<!--<a href="javascript:view_exp_scd('rtn','0','<%=ht.get("CAR_EXT")%>')"></a>--></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건<a href="javascript:exp_rtn_req_s('<%=ht.get("CAR_EXT")%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="환급신청서"></a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건<a href="javascript:exp_rtn_req('<%=ht.get("CAR_EXT")%>');"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="환급신청서"></a>&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>원&nbsp;&nbsp;</td>
                </tr>
<%			
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("AMT2")));
}%>			  
                <tr> 
                    <td align="center">계</td>
                    <td align="right"><%=Util.parseDecimal(sum1+sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2+sum4)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum1)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum3)%>건&nbsp;&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum4)%>원&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>			
	<tr>
	    <td>&nbsp;</td>
	</tr>
	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>
    <tr>
        <td><img src=/acar/images/center/arrow_dwys.gif align=absmiddle> : <%=AddUtil.getDate(1)%>년 <%=AddUtil.getDate(2)%>월 <a href="javascript:view_exp_est_mon('1')"><img src=/acar/images/center/button_yuy.gif border=0 align=absmiddle></a>&nbsp;<a href="javascript:view_exp_est_mon('2')"><img src=/acar/images/center/button_jgy.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan="2" class='title'>지역</td>
                    <td class='title' colspan="2">합계</td>
                    <td class='title' colspan="2">영업용</td>
                    <td class='title' colspan="2">업무용</td>
                </tr>
                <tr>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="15%">금액</td>
                </tr>	
          <%	
		  		sum1 = 0;
				sum2 = 0;
				sum3 = 0;
				sum4 = 0;
			  	for(int i = 0 ; i < scd_size5 ; i++){
					Hashtable ht = (Hashtable)scds5.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("CAR_EXT_NM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("CNT1")))+Util.parseInt(String.valueOf(ht.get("CNT2"))))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(Util.parseInt(String.valueOf(ht.get("AMT1")))+Util.parseInt(String.valueOf(ht.get("AMT2"))))%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%>원&nbsp;&nbsp;</td>
                </tr>
<%			
			sum1 = sum1 + Util.parseInt(String.valueOf(ht.get("CNT1")));
			sum2 = sum2 + Util.parseInt(String.valueOf(ht.get("AMT1")));
			sum3 = sum3 + Util.parseInt(String.valueOf(ht.get("CNT2")));
			sum4 = sum4 + Util.parseInt(String.valueOf(ht.get("AMT2")));
}%>			  
                <tr> 
                    <td align="center">계</td>
                    <td align="right"><%=Util.parseDecimal(sum1+sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2+sum4)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum1)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum2)%>원&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum3)%>건&nbsp;&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(sum4)%>원&nbsp;&nbsp;</td>
                </tr>				
            </table>
        </td>
    </tr>							
	<%}%>
</table>
</form>
</body>
</html>
