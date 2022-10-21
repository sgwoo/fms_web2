<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.client.*, tax.*, acar.car_mst.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	String mail_st 	= request.getParameter("mail_st")==null?"":request.getParameter("mail_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여갯수 카운터
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm = a_db.getMax_fee_tm(m_id, l_cd, rent_st);
	
	//거래처정보
	ClientBean client       = al_db.getClient(String.valueOf(base.get("CLIENT_ID")));
	
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(String.valueOf(base.get("CLIENT_ID")), String.valueOf(base.get("R_SITE")));
	
	//거래처담당자이메일
	Vector mgrs 			= al_db.getClientMgrEmailList(String.valueOf(base.get("CLIENT_ID")), "");
	int mgr_size = mgrs.size();
	
	
	String car_comp_id = "";
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(base.get("CAR_ID")), String.valueOf(base.get("CAR_SEQ")));
	
	car_comp_id = cm_bean.getCar_comp_id();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function ImEmail_Reg(){
		var fm = document.form1;	
		if(fm.l_cd.value == '')				{	alert('선택된 계약이 없습니다. 확인하십시오.'); return; }
		
		<%if(mail_st.equals("scd_fee_print")){%>
		
		<%}else{%>
			if(fm.max_fee_tm.value == '' || fm.max_fee_tm.value == '0')		{	alert('생성된 스케줄이 없습니다. 확인하십시오.'); return; }
		<%}%>
		
		if(fm.con_agnt_email.value == '')	{	alert('수신메일주소를 입력하십시오.'); return; }
		if(confirm('등록 하시겠습니까?'))
		{			
			fm.target = "i_no";
			fm.action = "fee_scd_email_reg_a.jsp";
			fm.submit();						
		}	
	}
	
	//대여료납입안내문
	function ImEmail_View(){
		var fm = document.form1;
		window.open("about:blank", "ScdDocView", "left=150, top=150, width=800, height=650, scrollbars=yes");				
		
		<%if(mail_st.equals("scd_fee_print")){%>
		fm.action = "/mailing/rent/scd_info.jsp";
		<%}else{%>
		fm.action = "/mailing/total/mail_service.jsp";
		<%}%>
		
		fm.target = "ScdDocView";
		fm.submit();
	}
	
	//받는 메일 셋팅
	function Email_Set(nm, email){
		var fm = document.form1;
		fm.con_agnt_nm.value 	= nm;
		fm.con_agnt_email.value = email;
	}
		
//메시지 입력시 string() 길이 체크
function checklen()
{
	var msgtext, msglen;
	
	msgtext = document.form1.msg.value;
	msglen = document.form1.msglen.value;
	
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>80)
		{
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 40자, 영문80자까지만 쓰실 수 있습니다.");
			temp = document.form1.msg.value.substr(0,i);
			document.form1.msg.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
}
	
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='max_fee_tm' value='<%=max_fee_tm%>'>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<!--<input type='hidden' name='firm_nm2' value='<%//=firm_nm2%>'>-->
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>

<input type='hidden' name='b_dt' value='<%=b_dt%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='bill_yn' value='<%=bill_yn%>'>
<input type='hidden' name='cls_chk' value='<%=cls_chk%>'>
<input type='hidden' name='mail_st' value='<%=mail_st%>'>
<input type='hidden' name='reg_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>

<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>
					<%if(mail_st.equals("scd_fee_print")){%>대여료스케줄안내문<%}else{%>대여료납입안내문<%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='15%' class='title'>계약번호</td>
                    <td width='20%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='15%' class='title'>상호</td>
                    <td width="50%">
                        &nbsp;<%=base.get("FIRM_NM")%>
                        &nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>
                <tr>
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=base.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>
                    </span></td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>&nbsp;
                        <%if(!cms.getCms_bank().equals("")){%>
					<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
                        <%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (매월 <%=cms.getCms_day()%>일)
                        <%}else{%>
        			      -
        			    <%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>관리담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>   
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>이메일 발송 리스트</span></td>
        <td align="right"></td>
    </tr>
<% 	String im_gubun = "scd_fee";
	if(mail_st.equals("scd_fee_print"))	im_gubun = "scd_info";
	
	Vector vts = ImEmailDb.getMailHistoryList("4", l_cd+""+im_gubun);
	int vt_size = vts.size();
	if(vt_size>0){%>
	<tr> 
        <td class=line2 colspan=2></td>
    </tr>		
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width="25%" class='title'>발송일시</td>
                    <td width="29%" class='title'>이메일주소</td>
                    <td width="25%" class='title'>열람일시</td>
                    <td width="8%" class='title'>수신여부</td>
                    <td width="8%" class='title'>발송상태</td>
                </tr>
              <%	for(int i = 0 ; i < vt_size ; i++){
    				      Hashtable ht = (Hashtable)vts.elementAt(i);%>		  
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
                    <td align='center'><%=ht.get("EMAIL")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
                    <td align='center'><%=ht.get("OCNT_NM")%></td>
                    <td align='center'><%=ht.get("MSGFLAG_NM")%></td>
                </tr>
              <%	}%>				  
            </table>
        </td>
    </tr>
	<%}%>
	<tr> 
        <td class=h></td>
    </tr> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처 담당자</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width="25%" class='title'>구분</td>
                    <td width="25%" class='title'>성명</td>
                    <td width="45%" class='title'>이메일주소</td>
                </tr>
              <%	for(int i = 0 ; i < mgr_size ; i++){
    				      Hashtable ht = (Hashtable)mgrs.elementAt(i);%>		  
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("MGR_ST")%></td>
                    <td align='center'><%=ht.get("MGR_NM")%></td>
                    <td align='center'><a href="javascript:Email_Set('<%=ht.get("MGR_NM")%>','<%=ht.get("MGR_EMAIL")%>');"><%=ht.get("MGR_EMAIL")%></a></td>
                </tr>
              <%	}%>		
                <tr>
                    <td align='center'><%=mgr_size+1%></td>
                    <td align='center'>세금계산서</td>
                    <td align='center'><%=client.getCon_agnt_nm()%></td>
                    <td align='center'><a href="javascript:Email_Set('<%=client.getCon_agnt_nm()%>','<%=client.getCon_agnt_email()%>');"><%=client.getCon_agnt_email()%></a></td>
                </tr>		  		  
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
        <td align="right"></td>
    </tr>		
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='15%' class='title'>이름</td>
                    <td width='85%'>&nbsp;
                    <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>EMAIL</td>
                    <td>&nbsp;
                    <input type='text' size='40' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
                </tr>
                <!-- 2018.04.23 -->
                <%if(mail_st.equals("scd_fee_print")){%>
                <tr>
                	<td class='title'>연장 구분</td>
                    <td>&nbsp;
                    	<%if(fee_count>1){%>
                    	<label><input type="radio" name="rst" value="all" checked="checked">전체</label>
                    	<%}%>
                    	<%for(int j=1; j<(fee_count+1); j++){
                    			if(j==1){
                    	%>
                    	<label><input type="radio" name="rst" value="<%=j%>" <%if(fee_count==1){%>checked="checked"<%}%>>신차대여</label>
                    	<%	continue;}
                    	%>
                    	<label><input type="radio" name="rst" value="<%=j%>" ><%=(j-1)%>차 연장</label>
                    	<%}%>
                    	<input type="hidden" name="fee_count" value="<%=fee_count%>">
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
	    <td><a href="javascript:ImEmail_View();"><img src=/acar/images/center/button_see_pre.gif border=0 align=absmiddle></a></td>
        <td align="right">
          <a href="javascript:ImEmail_Reg();"><img src=/acar/images/center/button_bh.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
		  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
        </td>
    </tr>		
</table>
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
//-->
</script>
</body>
</html>
