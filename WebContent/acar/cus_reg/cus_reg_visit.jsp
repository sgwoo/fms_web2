<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*, acar.cus_reg.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	ClientBean client = al_db.getClient(client_id);
	
	////Vector c_sites = al_db.getClientSites(client_id);
	//int c_site_size = c_sites.size();
	Vector conts = l_db.getContList(client_id);
	int cont_size = conts.size();
	//관리담당자
	CusReg_Database cr_db = CusReg_Database.getInstance();	
	Vector mngs = cr_db.getMng(client_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//Hashtable ht = cr_db.
	Hashtable ht = cr_db.getCycle_vst(client_id);
	Cycle_vstBean[] list = cr_db.getCycle_vstList(client_id);
	
	
	//height
	//int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//int cnt = 12; //현황 출력 영업소 총수
	//int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	//out.println("aa=" + height );
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//스케쥴생성하기
function create_scd_vst(){
	var fm = document.form1;
	if(fm.first_vst_dt.value==""){	alert("최초방문일을 입력해 주세요!"); fm.first_vst_dt.focus();	return; }
	if(fm.cycle_vst_mon.value==""){	alert("방문주기 개월을 입력해 주세요!"); fm.cycle_vst_mon.focus();	return; }
	//if(fm.cycle_vst_day.value==""){	alert("방문주기 일자를 입력해 주세요!"); fm.cycle_vst_day.focus();	return; }
	if(fm.tot_vst.value==""){	alert("총방문횟수를 입력해 주세요!"); fm.tot_vst.focus();	return; }
	if(get_length(fm.tot_vst.value)>2){	alert("최대 총 방문횟수는 99회까지입니다."); fm.tot_vst.focus(); return; }
	if(!confirm("스케쥴을 생성하시겠습니까?"))		return;	
	fm.action = "create_scd_vst.jsp";		
	fm.target = 'i_no';	
	fm.submit();
}
function extend_scd_vst(){
	var fm = document.form1;
	if(!confirm("스케쥴을 추가 생성하시겠습니까?"))		return;
	fm.action = "extend_scd_vst.jsp";
	fm.target = "i_no";
	fm.submit();
}
function ext_last_cont(){
	var fm = document.form1;
	if(fm.cycle_vst_mon.value==""){	alert("방문주기 개월을 입력해 주세요!"); fm.cycle_vst_mon.focus();	return; }
	if(get_length(fm.tot_vst.value)>2){	alert("최대 총 방문횟수는 99회까지입니다."); fm.tot_vst.focus(); return; }
	if(!confirm("최종계약일까지 연장하시겠습니까?")) return;
	fm.action = "extend_last_cont.jsp";
	fm.target = "i_no";
	fm.submit();
}
function deleteScdVst(seq){
	var fm = document.form1;
	fm.seq.value = seq;
	if(!confirm("해당 스케쥴을 삭제하시겠습니까?"))	 return;
	fm.action = "delete_scd_vst.jsp";
	fm.target = "i_no";
	fm.submit();	
}
//다음방문일변경
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="seq" value="">
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                              <td class='title'>상호</td>
                              <td class='left'>&nbsp;<b><%=client.getFirm_nm()%></b></td>
                              <td class=title>계약자</td>
                              <td class='left' colspan="3">&nbsp;<%=client.getClient_nm()%></td>
                            </tr>
                            <tr> 
                              <td class='title'>사용본거지</td>
                              <td class='left' colspan="5">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class='title'>사업장 주소</td>
                              <td class='left' colspan="5">&nbsp; <%if(!client.getO_addr().equals("")){%>
                                ( 
                                <%}%> <%=client.getO_zip()%> <%if(!client.getO_addr().equals("")){%>
                                )&nbsp; <%}%> <%=client.getO_addr()%></td>
                            </tr>
                            <tr> 
                              <td class='title' width=13%>회사전화번호</td>
                              <td class='left' width=24%>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
                              <td class='title' width=12%>휴대폰</td>
                              <td class='left' width=20%>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
                              <td class='title' width=12%>자택전화번호</td>
                              <td class='left' width=19%>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약리스트</span></td>
                    <td align="right"><img src=/acar/images/center/arrow.gif align=absmiddle> 진행중인 계약 건수 : 
                    <input type='text' name='valid_cont_cnt' class='whitenum' size='4' value='' readonly>
                    건&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>                
                <tr> 
                    <td colspan="2">
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                              <td class='line'> 
                                    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                  <!-- 계약코드, 계약일, 차량번호, 차명, 계약기간, 대여방식, 대여기간, 대여구분, 영업담당//-->
                                      <tr> 
                                        <td width='13%' class=title>계약번호</td>
                                        <td width='12%' class=title>계약일</td>
                                        <td width='13%' class=title>차량번호</td>
                                        <td width='17%' class=title>차명</td>
                                        <td width='18%' class=title>계약기간</td>
                                        <td width='9%' class=title>대여방식</td>
                                        <td width='9%' class=title>영업담당</td>
                                        <td width='9%' class=title>대여구분</td>
                                      </tr>
                                    </table>
                               </td>
                              <td width=16></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"><iframe src="cus_reg_con_s.jsp?client_id=<%=client_id%>" name="inner1" width="100%" height="<%if(cont_size>=4){ out.print("90"); 
    		  }else if(cont_size==3){ 
    		  	out.print("70"); 
    		  }else if(cont_size==2){
    		  	out.print("50"); 
    		  }else if(cont_size==1){ 
    		  	out.print("30"); 
    		  }else{
    		  } %>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                  </iframe></td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td valign="bottom"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처방문 스케줄</span></td>
                    <td align="right"> 
                  <!--<font color="#666666"> ♣ <a href="javascript:MM_openBrWindow('client_loop2.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=600,height=600,top=50,left=50')">거래처방문주기</a> 
                  : <font color="#FF0000">한달</font></font>-->
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table border="0" cellspacing="0" cellpadding="0" width='100%'>
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class=line>
                                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                                        <tr> 
                                          <td class='title' width=13%>관리담당자</td>
                                          <td width=13%>&nbsp;<% for(int i = 0 ; i < mngs.size() ; i++){
                        			String mng_id = (String)mngs.elementAt(i);
                        			out.print(c_db.getNameById(mng_id,"USER")+" ");
                        			}%></td>
                                          <td class='title' width=12%>최초방문일자</td>
                                          <td width=13%>&nbsp; <input type="text" name="first_vst_dt" size="12" class=text value="<%= AddUtil.ChangeDate2((String)ht.get("FIRST_VST_DT")) %>" onBlur='javascript:this.value=ChangeDate(this.value);'> 
                                          </td>
                                          <td class='title' width=12%>방문주기</td>
                                          <td width=13%>&nbsp; <input type="text" name="cycle_vst_mon" size="2" class=text value="<%= ht.get("CYCLE_VST_MON") %>">
                                            개월 
                                            <input type="text" name="cycle_vst_day" size="2" class=text value="<%= ht.get("CYCLE_VST_DAY") %>">
                                            일</td>
                                          <td class='title' width=12%>총방문횟수</td>
                                          <td width=13%>&nbsp; <input type="text" name="tot_vst" size="3" class=text value="<%= ht.get("TOT_VST") %>">
                                            회</td>
                                           
                                        </tr>
                                    </table>
                                </td>
                                <td width=16>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td  align="left">&nbsp;</td>
                    <td  align="right">
        			  <% if(list.length>0){ %>
        			        <a href="javascript:MM_openBrWindow('vst_reg.jsp?client_id=<%= client_id %>','popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=350,top=50,left=50')"><img src=/acar/images/center/button_reg_bjg.gif align=absmiddle border=0></a>&nbsp; 
                            <a href="javascript:MM_openBrWindow('scd_vst_cng_dt.jsp?client_id=<%= client_id %>','popwin_scd_vst_cng_dt','scrollbars=no,status=no,resizable=no,width=550,height=200,top=200,left=300')"><img src=/acar/images/center/button_modify_yji.gif align=absmiddle border=0></a>&nbsp; 
        			        <a href="javascript:ext_last_cont()"><img src=/acar/images/center/button_gy_yj.gif align=absmiddle border=0></a>
        			  <% }else{ %>
                      	    <a href="javascript:create_scd_vst()"><img src=/acar/images/center/button_sch_cre.gif align=absmiddle border=0></a> 
                      <% } %>&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td></td>
                </tR>
                <tr> 
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></tD>
                            </tr>
                            <tr> 
                              <td class="line">
                                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                                  <tr> 
                                    <td class='title' width=4%>회차</td>
                                    <td class='title' width=11%>방문예정일</td>
                                    <td class='title' width=11%>방문일자</td>
                                    <td class='title' width=10%>방문자</td>
                                    <td class='title' width=12%>방문목적</td>
                                    <td class='title' width=11%>상담자</td>
                                    <td class='title' width=25%>상담내용</td>
                                    <td class='title' width=8%>등록</td>
                                    <td class='title' width=8%>삭제</td>
                                  </tr>
                                </table></td>
                                <td width=16>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"><iframe src="cus_reg_visit_in.jsp?client_id=<%=client_id%>" name="scd_vst" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
