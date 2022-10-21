<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_sche.*, acar.schedule.*, acar.car_sche.*, acar.car_service.*, acar.esti_mng.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="ts_bean" class="acar.car_sche.TodayScheBean" scope="page"/>
<jsp:useBean id="ts2_bean" class="acar.car_sche.TodaySche2Bean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="EstiMngDb" scope="page" class="acar.esti_mng.EstiMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?br_id:request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_user_id = request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");	
	if(s_month.length() == 1)	s_month = "0"+s_month;
	if(s_day.length() == 1)		s_day = "0"+s_day;
	
	Vector prvs = aa_db.getUserPrvContent2(s_brch_id, s_dept_id,s_user_id, s_year, s_month, s_day, seq);

	/*
	CusSch_Database cs_db = CusSch_Database.getInstance();
	Cycle_vstBean[] cvBns = cs_db.getCycle_vstAll(s_year, s_month, s_day);
	Vector sl = cs_db.getServiceAll(s_year, s_month, s_day);
	Vector cml = cs_db.getCar_maintAll(s_year, s_month, s_day);
	*/
	CarSchDatabase csd = CarSchDatabase.getInstance();
	TodayScheBean[] tsbns = csd.getTodaySche(s_user_id,s_year+s_month+s_day);
	TodaySche2Bean[] ts2bns = csd.getTodaySche2(s_user_id,s_year+s_month+s_day);	
	CarServDatabase csdb = CarServDatabase.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//정비 등록 팝업윈도우 열기
function serv_reg(car_mng_id, serv_id){
	var SUBWIN="/acar/cus_reg/serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id; 
	window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=700,top=50,left=50');
}

	//견적내용보기
	function EstiDisp(est_id){
		var SUBWIN="/acar/esti_ing/esti_ing_u.jsp?est_id=" + est_id + "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=user_id%>&gubun3=7&s_dt=<%=s_year+s_month+s_day%>&s_dt=<%=s_year+s_month+s_day%>&mode=view"; 
		window.open(SUBWIN, 'popwin_esti_ing','scrollbars=yes,status=no,resizable=no,width=870,height=600,top=50,left=50');
//		var fm = document.form1;
//		fm.est_id.value = est_id;
//		fm.target = 'd_content';
//		fm.submit();
	}
		
//-->
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1  cellpadding="0" width=100%>
<%		//고객지원팀
		if(s_user_id.equals("000010")||s_user_id.equals("000011")||s_user_id.equals("000012")
		||s_user_id.equals("000013")||s_user_id.equals("000025")||s_user_id.equals("000020")||s_user_id.equals("000023")
		||s_user_id.equals("000026")||s_user_id.equals("000034")){		%>
                <tr> 
                    <td align="center" colspan="6"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class=h colspan=3></td>
                                        </tr>
                                        <tr> 
                                            <td align="center">&nbsp;</td>
                                            <td align="right"><img src=../images/center/arrow_jsj.gif align=absmiddle> : <%= c_db.getNameById(s_user_id,"USER") %> &nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jsi.gif align=absmiddle> : 
                                            <%= s_year %>-<%=s_month%>-<%=s_day%>&nbsp;&nbsp;</td>
                                            <td align="center">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3">&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처방문</span></td>
                                        </tr> 
                                        <tr> 
                                            <td width="10">&nbsp;</td>
                                            <td width="100%" class="line">
                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                    <tr>
                                                        <td class=line2 colspan=4 style='height:1'></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="5%" class="title">연번</td>
                                                        <td width="20%" class="title">거래처명</td>
                                                        <td width="10%" class="title">방문구분</td>
                                                        <td width="65%" class="title">방문내용</td>
                                                    </tr>
                                              <%if(ts2bns.length>0){
                    							for(int i=0; i<ts2bns.length; i++){
                    								ts2_bean = ts2bns[i];%>
                                                    <tr> 
                                                        <td align="center"><%= i+1 %></td>
                                                        <td>&nbsp;<%= ts2_bean.getFirm_nm() %></td>
                                                        <td align=center><%= ts2_bean.getVst_title() %></td>
                                                        <td>&nbsp;<%= ts2_bean.getVst_cont() %></td>
                                                    </tr>
                                              <%}
                    						}else{%>
                                                    <tr> 
                                                        <td height="13" colspan="4"><div align="center">당일 
                                                        거래처 방문건이 없습니다.</div></td>
                                                    </tr>
                                              <%}%>
                                                </table>
                                            </td>
                                            <td width="10">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3></td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3">&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차관리</span></td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td class="line">
                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                    <tr>
                                                        <td class=line2 colspan=6 style='height:1'></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width=5% class="title">연번</td>
                                                        <td width=10% class="title">차량번호</td>
                                                        <td width=23% class="title">차종</td>
                                                        <td width=20% class="title">상호</td>
                                                        <td width=10% class="title">정비구분</td>
                                                        <td width=32% class="title">정비내용</td>
                                                    </tr>
                                              <%if(tsbns.length>0){
                    							for(int i=0; i<tsbns.length; i++){
                    								ts_bean = tsbns[i];%>
                                                    <tr> 
                                                        <td align="center"><%= i+1 %></td>
                                                        <td align="center"><%= ts_bean.getCar_no() %></td>
                                                        <td>&nbsp;<span title="<%= ts_bean.getCar_name() %>"><%= AddUtil.subData(ts_bean.getCar_name(),20) %></span></td>
                                                        <td>&nbsp;<span title="<%= ts_bean.getFirm_nm() %>"><%= AddUtil.subData(ts_bean.getFirm_nm(),10) %></span></td>
                                                        <td align="center"><%if(ts_bean.getServ_st().equals("1"))	out.print("순회점검"); 
                            												else if(ts_bean.getServ_st().equals("2"))	out.print("일반수리");
                            												else if(ts_bean.getServ_st().equals("3"))	out.print("보증수리");
                            												else if(ts_bean.getServ_st().equals("4"))	out.print("운행자차");
                            												else if(ts_bean.getServ_st().equals("5"))	out.print("사고자차");
                            												else if(ts_bean.getServ_st().equals("8"))	out.print("정기검사");
                            												else if(ts_bean.getServ_st().equals("9"))	out.print("정기정밀");												
                            												else				out.print(""); %></td>
                                                        <td><% if(ts_bean.getServ_st().equals("8")||ts_bean.getServ_st().equals("9")){ %>
                            										&nbsp;<%=Util.subData(ts_bean.getRep_cont(),10)%>
                            								<% }else{ %>
                            							&nbsp;<a href="javascript:serv_reg('<%=ts_bean.getCar_mng_id()%>','<%=ts_bean.getServ_id()%>')">
                            							<% if(!ts_bean.getServ_dt().equals("")){ 
                            											if((ts_bean.getServ_st().equals("2")||ts_bean.getServ_st().equals("3"))&&(AddUtil.parseInt(ts_bean.getServ_dt())>20031231)){ %>
                            									  [순회]
                            									  <% %>
                            									   
                            									  <%	}
                            									  } %>
                            									  <%	String rep_cont = "";
                            									  		if((ts_bean.getServ_st().equals("2")||ts_bean.getServ_st().equals("3")||ts_bean.getServ_st().equals("4"))&&(AddUtil.parseInt(ts_bean.getServ_dt())>20031231)){									  		
                            											ServItem2Bean si_r [] = csdb.getServItem2All(ts_bean.getCar_mng_id(), ts_bean.getServ_id());
                            											for(int j=0; j<si_r.length; j++){
                            												si_bean = si_r[j];
                            												if(j==si_r.length-1){
                            														rep_cont = si_bean.getItem();
                            												}else{
                            														rep_cont = si_bean.getItem()+",";
                            												}            	
                            											}										
                            									  %>
                            												 										
                            											<%}else{%>
                            												
                            											<%}%>
                            									  <%if((ts_bean.getServ_st().equals("2")||ts_bean.getServ_st().equals("3")||ts_bean.getServ_st().equals("4"))&&(AddUtil.parseInt(ts_bean.getServ_dt())>20031231)){
                            											ServItem2Bean si_r [] = csdb.getServItem2All(ts_bean.getCar_mng_id(), ts_bean.getServ_id());
                            											for(int j=0; j<si_r.length; j++){
                            												si_bean = si_r[j];
                            												if(j==0){%>
                            												  <span title="<%= rep_cont%>"><%=si_bean.getItem()%><% if(si_r.length>1){ %>외 <font color="red"><%=si_r.length-1%></font>건 <% } %></span> 
                            												<%}
                            											}
                            										
                            										}else{%>
                            											<span title="<%= ts_bean.getRep_cont() %>"><%=Util.subData(ts_bean.getRep_cont(),10)%></span>		
                            									<%  } %> 
                            									  </a>
                            								<% } %></td>
                                                    </tr>
                                              <%	}
                    						}else{%>
                                                    <tr> 
                                                        <td colspan="6"><div align="center">당일 자동차 정비건이 없습니다.</div></td>
                                                    </tr>
                                          <%}%>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                    				<%for(int k=0; k<prvs.size(); k++){
                    					Hashtable ht = (Hashtable)prvs.elementAt(k);%>
                    			        <tr>
					                        <td colspan=3></td>
					                    </tr>
                                        <tr> 
                                            <td colspan="3">&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타 (<%=  ht.get("DT") %>)</span></td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td><textarea name="textarea" cols="168" rows="5"><%=  ht.get("CONTENT") %></textarea></td>
                                            <td>&nbsp;</td>
                                        </tr>
                    				<% } %>
                                    </table>
                                </td>
                            </tr>
                    	    <tr><td>&nbsp;</td></tr>
                        </table>
                    </td>
                </tr>
<%
		}else if(s_user_id.equals("000024")||s_user_id.equals("000027")||s_user_id.equals("000028")
		||s_user_id.equals("000039")||s_user_id.equals("000049")||s_user_id.equals("000050")||s_user_id.equals("000051")){		%>
                <tr> 
                    <td align="center" colspan="6"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class=h colspan=3></td>
                                        </tr>
                                        <tr> 
                                            <td align="center">&nbsp;</td>
                                            <td align="right"><img src=../images/center/arrow_jsj.gif align=absmiddle> : <%= c_db.getNameById(s_user_id,"USER") %>&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jsi.gif align=absmiddle> : 
                                            <%= s_year %>-<%=s_month%>-<%=s_day%>&nbsp;&nbsp;</td>
                                            <td align="center">&nbsp;</td>
                                        </tr>
<%						
	Vector EstiIngList = EstiMngDb.getEstiList("Y", "", s_user_id, "", "7", "", "", "", s_year+s_month+s_day, s_year+s_month+s_day, "", "", "", "", "", "", "", "");
	Vector EstiEndList = EstiMngDb.getEstiList("N", "", s_user_id, "", "7", "", "", "", s_year+s_month+s_day, s_year+s_month+s_day, "", "", "", "", "", "", "", "");
	
%>
                                        <tr> 
                                            <td colspan="3">&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적진행관리</span></td>
                                        </tr>
                                        <tr> 
                                            <td width="10">&nbsp;</td>
                                            <td width="100%" class="line"> 
                                                <table border="0" cellspacing="1" cellpadding="0" width="100%">
                                                    <tr>
                                                        <td class=line2 colspan=8 style='height:1'></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width= 30 class=title>연번</td>
                                                        <td width= 100 class=title>영업사원명</td>
                                                        <td width= 170 class=title>거래처명</td>
                                                        <td width= 200 class=title>차종</td>
                                                        <td width= 90 class=title>견적일자</td>
                                                        <td width= 90 class=title>Update일자</td>
                                                        <td width= 60 class=title>담당자</td>
                                                        <td width= 60 class=title>진행상태</td>
                                                    </tr>						
                          <% if(EstiIngList.size()>0){
				for(int i=0; i<EstiIngList.size(); i++){ 
					Hashtable ht = (Hashtable)EstiIngList.elementAt(i); 
					String ment = "";
					if(!String.valueOf(ht.get("CNT")).equals("0")){
//						ment = "["+ AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT"))) +"] "+ ht.get("TITLE") +"\n\n"+ ht.get("CONT");
						ment = "제목: "+ ht.get("TITLE") +"\n\n내용: "+ ht.get("CONT");						
					}
					String reg_dt = AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")));
					%>
                                                    <tr> 
                                                        <td width=30 align=center><%= i+1 %></td>
                                                        <td width=100 align=center> <span title='<%= ht.get("CAR_COMP_NM") %> <%= ht.get("CAR_OFF_NM") %>'><%=Util.subData(String.valueOf(ht.get("EMP_NM"))+" "+String.valueOf(ht.get("EMP_POS")), 7)%></span>	
                                                        </td>
                                                        <td width=170 align=center> <span title='<%= ht.get("EST_NM") %> <%= ht.get("EST_MGR") %>'><%=Util.subData(String.valueOf(ht.get("EST_NM"))+" "+String.valueOf(ht.get("EST_MGR")), 13)%></span> 
                                                        </td>
                                                        <td width=200 align=center> 
                                                          <%if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){%>
                                                          <span title='<%= ht.get("CAR_NAME") %>'><font color="#990000">[<%= ht.get("CAR_NO") %>]</font> 
                                                          <%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 12)%></span> 
                                                          <%}else{%>
                                                          <span title='<%= ht.get("CAR_NAME") %>'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 20)%></span> 
                                                          <%}%>
                                                        </td>
                                                        <td width=90 align=center><a href="javascript:EstiDisp('<%= ht.get("EST_ID") %>')"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT"))) %></a></td>
                                                        <td width=90 align=center><span title='<%= ment %>'><%= AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT"))) %></span></td>
                                                        <td width=60 align=center><%= ht.get("MNG_NM") %></td>
                                                        <td width=60 align=center><%= ht.get("EST_ST_NM") %></td>
                                                    </tr>
                          <% 		}
			}else{ %>
                                                    <tr> 
                                                        <td colspan="8" align='center'>해당 데이터가 없습니다.</td>
                                                    </tr>
                          <% } %>
                                                </table>
                                            </td>
                                            <td width="10">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3></td>
                                        </tr>
                                        <tr> 
                                            <td colspan="3">&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적마감관리</span></td>
                                        </tr> 
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td class="line" width="100%"> 
                                                <table border="0" cellspacing="1" cellpadding="0" width="100%">
                                                    <tr>
                                                        <td colspan=8 class=line2 style='height:1'></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width= 30 class=title>연번</td>
                                                        <td width= 100 class=title>영업사원</td>
                                                        <td width= 150 class=title>거래처명</td>
                                                        <td width= 200 class=title>차종</td>
                                                        <td width= 80 class=title>마감일자</td>
                                                        <td width= 60 class=title>담당자</td>
                                                        <td width= 80 class=title>견적결과</td>
                                                        <td width= 100 class=title>미체결내용</td>
                                                    </tr>						
                          <% if(EstiEndList.size()>0){
				for(int i=0; i<EstiEndList.size(); i++){ 
					Hashtable ht = (Hashtable)EstiEndList.elementAt(i); %>
                                                    <tr> 
                                                        <td width=30 align=center><%= i+1 %></td>
                                                        <td width=100 align=center>  
                                                          <span title='<%= ht.get("CAR_COMP_NM") %> <%= ht.get("CAR_OFF_NM") %>'><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 5)%></span> 
                                                           </td>
                                                        <td width=150 align=center> 
                                                          <span title='<%= ht.get("EST_NM") %> <%= ht.get("EST_MGR") %>'><%=Util.subData(String.valueOf(ht.get("EST_NM"))+" "+String.valueOf(ht.get("EST_MGR")), 10)%></span> 
                                                           </td>
                                                        <td width=200 align=center> 
                                                          <%if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){%>
                                                          <font color="#990000">[<%= ht.get("CAR_NO") %>]</font> 
                                                          <span title='<%= ht.get("CAR_NAME") %>'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 10)%></span> 
                                                          <%}else{%>
                                                          <span title='<%= ht.get("CAR_NAME") %>'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 15)%></span> 
                                                          <%}%>
                                                        </td>
                                                        <td width=80 align=center><a href="javascript:EstiDisp('<%= ht.get("EST_ID") %>')"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT"))) %></a></td>
                                                        <td width=60 align=center><%= ht.get("MNG_NM") %></td>
                                                        <td width=80 align=center><%= ht.get("END_TYPE_NM") %></td>
                                                        <td width=100 align=center><span title='<%= ht.get("CONT") %>'><%= ht.get("NEND_ST_NM") %></span></td>
                                                    </tr>
                          <% 		}
			}else{ %>
                                                    <tr> 
                                                        <td colspan="8" align='center'>해당 데이터가 없습니다.</td>
                                                    </tr>
                          <% } %>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
				<%for(int k=0; k<prvs.size(); k++){
					Hashtable ht = (Hashtable)prvs.elementAt(k);%>
					                    <tr>
					                        <td colspan=3></td>
					                    </tr>
                                        <tr> 
                                            <td colspan="3">&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타 (<%=  ht.get("DT") %>)</span></td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td>
                                                <textarea name="textarea" cols="172" rows="5"><%=  ht.get("CONTENT") %></textarea>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
				<% } %>
                                    </table>
                                </td>
                            </tr>
			                <tr><td>&nbsp;</td></tr>
                        </table>
                    </td>
                </tr>		
        <%}else{%>
			<%for(int k=0; k<prvs.size(); k++){
				Hashtable ht = (Hashtable)prvs.elementAt(k);%>
                <tr> 
                    <td class='title' height="21" colspan="6">업무일지</td>
                </tr>
                <tr> 
                    <td class='title' width="7%">성명</td>
                    <td class='title' width=9% style='text-align:left'>&nbsp;<input type="text" name="name" size="13" class=text value="<%= ht.get("USER_NM") %>"> 
                    </td>
                    <td class='title' width="10%">업무일자</td>
                    <td class='title' width=9% style='text-align:left'>&nbsp;<input type="text" name="dt" size="10" class=text value="<%= ht.get("DT") %>"> 
                    </td>
                    <td class='title' width="7%">제목</td>
                    <td class='title' width=58% style='text-align:left'>&nbsp;<input type="text" name="title" size="95" class=text value="<%= ht.get("TITLE") %>"> 
                    </td>
                </tr>
                <tr> 
                    <td align="left" colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="content" cols="163" rows="10" class=default><%=  ht.get("CONTENT") %></textarea> 
                    </td>
                </tr>
        <%	}
		}%>
            </table>
        </td>
    </tr>
</table>    		
</body>

</html>
