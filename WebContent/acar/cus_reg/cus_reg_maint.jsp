<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*, acar.cus_reg.*"%>
<%@ page import="acar.car_register.*, acar.res_search.*" %>
<jsp:useBean id="cm_bean" class="acar.car_register.CarMaintBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mdata = request.getParameter("mdata")==null?"":request.getParameter("mdata");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	ClientBean client = al_db.getClient(client_id);
	
	CarInfoBean carinfoBn = cr_db.getCarInfo(car_mng_id);
	
	Vector mngs = cr_db.getMng(client_id);
	
	//정기검사
	CarMaintBean cm_r [] = crd.getCarMaintAll(car_mng_id);
	
	String m1_dt = "";
	
	m1_dt =  cr_db.getMaster_dt(car_mng_id);
	
	//차량번호 이력
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	//대차관리 배차상태
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	Hashtable reserv2 = rs_db.getResCarCase(car_mng_id, "1");
	String use_st2 = String.valueOf(reserv2.get("USE_ST"))==null?"":String.valueOf(reserv2.get("USE_ST"));		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();
	}
		
	//스캔한 등록증 보기
	function view_scanfile2(path){
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		
		var size = 'width=700, height=650, scrollbars=yes';
		theURL ="https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf";
		popObj = window.open('', "SCAN", "left=50, top=30,"+size+", resizable=yes, scrollbars=yes, status=yes");
		
		popObj.location = theURL;
		popObj.focus();
	}		
	
function modifyMaint(seq_no, che_dt, che_kd){
	<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.maint_id.value = seq_no;
		ofm.maint_dt.value = che_dt;	
		if(che_kd == '1') 		ofm.p_cont.value = ofm.p_cont.value+' 정기검사';	
		if(che_kd == '2') 		ofm.p_cont.value = ofm.p_cont.value+' 정기정밀검사';			
		self.close();			
	<%}else{%>
		var fm = document.form1;
		fm.seq_no.value = seq_no;	
		fm.action = 'cus_reg_maint_in.jsp';
		fm.target = 'maint_in';
		fm.submit();
	<%}%>
}
function go_visit(firm_nm){
	parent.location.href = "cus_reg_frame.jsp?s_gubun1=1&s_kd=1&t_wd="+firm_nm;
}

	//스캔한 등록증 보기
function view_scanfile(idx){
		var  path = "";
		<% if(ch_r.length > 1){ %>
			path = document.form1.scanfile[idx].value;
		<% }else{ %>
			path = document.form1.scanfile.value;
		<% } %>
		
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes, scrollbars=yes, status=yes");
}	

//예약이력
function view_sh_res_h(){
	var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";
	window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
}	
	
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="go_url" value="<%= go_url %>">
<input type="hidden" name="seq_no" value="">
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class='title'>상호&nbsp; </td>
                                <td class='left' colspan="3">&nbsp;
                                	<%if(from_page.equals("master_maint_sc_in.jsp")){ %>
                                		<%=client.getFirm_nm()%>
                                	<%}else{ %>
                                	<a href="javascript:go_visit('<%=client.getFirm_nm()%>')"><%=client.getFirm_nm()%></a>
                                	<%} %>
                                	&nbsp;
                                	<%if(!use_st.equals("null")){%>
                              		( [배차] <%=reserv.get("RENT_ST")%> &nbsp;<%=reserv.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              		<%}else{ %>
                              		<%	if(!use_st2.equals("null")){%>
                              		( [예약] <%=reserv2.get("RENT_ST")%> &nbsp;<%=reserv2.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              		<%	} %>
                              		<%} %>
                                </td>
                                <td class='title'>계약자</td>
                                <td class='left' colspan="3">&nbsp;<%=client.getClient_nm()%></td>
                            </tr>
                         
                            <tr> 
                                <td class='title'>차량번호</td>
                                <td class='left'>&nbsp;<b><%= carinfoBn.getCar_no() %></b></td>
                                <td class='title'>차명</td>
                                <td class='left' colspan="5">&nbsp;<b><%= carinfoBn.getCar_jnm()+" "+carinfoBn.getCar_nm() %></b></td>
                            </tr>
                            <tr> 
                                <td class='title' width=14%>최초등록일</td>
                                <td class='left' width=13%>&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getInit_reg_dt()) %></td>
                                <td class='title' width=10%>연료</td>
                                <td class='left' width=15%><b> 
                                &nbsp;<%=c_db.getNameByIdCode("0039", "", carinfoBn.getFuel_kd())%>
                                
                                </b> </td>
                                <td class='title' width=14%>배기량</td>
                                <td class='left' width=11%>&nbsp;<%= carinfoBn.getDpm() %> cc</td>
                                <td class='title' width=10%>색상</td>
                                <td class='left' width=11%>&nbsp;<%= carinfoBn.getColo() %></td>
                            </tr>  
                            <tr> 
                                <td class='title'>일반성보증</td>
                                <td class='left' colspan="3">&nbsp;<%= carinfoBn.getGuar_gen_y() %> 년 <%= AddUtil.parseDecimal(carinfoBn.getGuar_gen_km()) %> Km</td>
                                <td class='title'>내구성보증</td>
                                <td class='left' colspan="3">&nbsp;<%= carinfoBn.getGuar_endur_y() %> 년 <%= AddUtil.parseDecimal(carinfoBn.getGuar_endur_km()) %> Km</td>
                            </tr>
                            
                                <tr> 
                                <td class='title'>지역</td>
                                <td class='left' >&nbsp;
                                	  <%=c_db.getNameByIdCode("0032", "", carinfoBn.getCar_ext())%>
                                </td>
                                <td class='title'>차종</td>
                                <td class='left' >&nbsp;
                                      <%=c_db.getNameByIdCode("0041", "", carinfoBn.getCar_kd())%>	                                 
                                </td>
                           	    <td class='title'>용도</td>
                                <td class='left' >&nbsp;
                        			 <%if(carinfoBn.getCar_use().equals("1")){%> 영업용 <%}%>
                        			 <%if(carinfoBn.getCar_use().equals("2")){%> 자가용 <%}%>
                                </td>
                                <td class='title'>차령만료일</td>
                                <td class='left' >&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getCar_end_dt()) %></td>
                          
                            </tr>
                            <tr> 
                                <td class='title'>정기검사유효기간</td>
                                <td class='left' colspan="3">&nbsp;<a href="javascript:set_maint_dt('<%= AddUtil.ChangeDate2(carinfoBn.getMaint_st_dt()) %>','<%= AddUtil.ChangeDate2(carinfoBn.getMaint_end_dt()) %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%= AddUtil.ChangeDate2(carinfoBn.getMaint_st_dt()) %> ~ <%= AddUtil.ChangeDate2(carinfoBn.getMaint_end_dt()) %></a></td>
                                <td class='title'>정기점검유효기간</td>
                                <td class='left' colspan="3">&nbsp;<a href="javascript:set_maint_dt('<%= AddUtil.ChangeDate2(carinfoBn.getTest_st_dt()) %>','<%= AddUtil.ChangeDate2(carinfoBn.getTest_end_dt()) %>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%= AddUtil.ChangeDate2(carinfoBn.getTest_st_dt()) %> ~ <%= AddUtil.ChangeDate2(carinfoBn.getTest_end_dt()) %></a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 이력</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=7%>연번</td>
                    <td class=title width=13%>변경일자</td>
                    <td class=title width=16%>자동차관리번호</td>
                    <td class=title width=18%>사유</td>
                    <td class=title width=30%>상세내용</td>
                    <td class=title width=16%>등록증스캔</td>			
                </tr>
                <%if(ch_r.length > 0){
				for(int i=0; i<ch_r.length; i++){
			        ch_bean = ch_r[i];	%>
                <tr> 
                    <td align="center"><%=ch_bean.getCha_seq()%></td>
                    <td align="center"><%=ch_bean.getCha_dt()%></td>
                    <td align="center"><%=ch_bean.getCha_car_no()%></td>
                    <td align="center"> 
                      <% if(ch_bean.getCha_cau().equals("1")){%>
                      사용본거지 변경 
                      <%}else if(ch_bean.getCha_cau().equals("2")){%>
                      용도변경 
                      <%}else if(ch_bean.getCha_cau().equals("3")){%>
                      기타 
                      <%}else if(ch_bean.getCha_cau().equals("4")){%>
                      없음
                      <%}else if(ch_bean.getCha_cau().equals("5")){%>신규등록<%}%>			  
        			  </td>
                    <td bgcolor="#FFFFFF">&nbsp;<%=ch_bean.getCha_cau_sub()%></td>
                    <td align="center" >&nbsp;
                     <input type='hidden' name='scanfile' value='<%=ch_bean.getScanfile()%>'> 
        		   <%if(!ch_bean.getScanfile().equals("")){%>
					<%		if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:view_scanfile2('<%=ch_bean.getScanfile()%>');"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%		}else{%>
    			    <a href="javascript:ScanOpen('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
					<%		}%>						   
        			<%} %>        
        				
        			</td>			
                </tr>
          <%	}
			}else{%>
                <tr> 
                    <td colspan=5 align=center>등록된 데이타가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>				
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운행차검사</span>&nbsp;&nbsp;
                    <% if (!m1_dt.equals("") ){ %>최종 위탁검사 의뢰일:<%=m1_dt%><%}%>                  
                    </td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class="line">
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                                <td width=4% rowspan=2 class=title>연번</td>
                                <td width=12% rowspan=2 class=title>점검종별</td>
                                <td class=title colspan=3>점검정비 유효기간</td>
                                <td class=title colspan=4>검사내용</td>
                            </tr>
                            <tr> 
                                <td width=11% class=title>연월일부터</td>
                                <td width=11% class=title>연월일까지</td>
                                <td width=11% class=title>점검일자</td>
                                <td width=12% class=title>담당자</td>
                                <td width=15% class=title>검사소</td>
                                <td width=12% class=title>비용(원)</td>
                                <td width=12% class=title>주행거리(Km)</td>
                            </tr>
            <%if(cm_r.length>0){
			    for(int i=0; i<cm_r.length; i++){
		        cm_bean = cm_r[i]; %>
                            <tr> 
                                <td align="center"  rowspan=2><%= i+1 %></td>
                                <td align="center"><a href="javascript:modifyMaint('<%= cm_bean.getSeq_no() %>', '<%=cm_bean.getChe_dt()%>', '<%=cm_bean.getChe_kd()%>')"> 
                                <%if(cm_bean.getChe_kd().equals("1")){%>
                    	            정기검사 
                                <% }else if(cm_bean.getChe_kd().equals("2")){%>
                	                정기정밀검사 
            					<% }else if(cm_bean.getChe_kd().equals("3")){%>
            	                    정기점검
                                <% } %>
                                </a>                             
                                 </td>
                                <td align="center"><%=cm_bean.getChe_st_dt()%></td>
                                <td align="center"><%=cm_bean.getChe_end_dt()%></td>
                                <td align="center"><%=cm_bean.getChe_dt()%></td>
                                <td align="center"><%if(!cm_bean.getChe_no().equals("")){
            											if(cm_bean.getChe_no().substring(0,2).equals("00")){
            												out.print(login.getAcarName(cm_bean.getChe_no()));
            											}else{
            									            out.print(cm_bean.getChe_no());
            											}
            									}%></td>
                                <td align="center"><%=cm_bean.getChe_comp()%></td>
                                <td align="right"><%=AddUtil.parseDecimal(cm_bean.getChe_amt())%>&nbsp;&nbsp;</td>
                                <td align="right"><%=AddUtil.parseDecimal(cm_bean.getChe_km())%>&nbsp;&nbsp;</td>
                            </tr>
                            <tr> 
                              <td align="center" colspan=8><%=cm_bean.getChe_remark()%></td>
                            </tr>
            				<% }
            				}else{ %>
                            <tr> 
                                <td colspan="9" align="center">해당 데이터가 없습니다.</td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td><iframe src="cus_reg_maint_in.jsp?mdata=<%=mdata%>&car_mng_id=<%= car_mng_id %>&client_id=<%= client_id %>&go_url=<%=go_url%>" name="maint_in" width="100%" height="260" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--
	function set_maint_dt(st_dt, end_dt){
		maint_in.document.form1.che_st_dt.value 	= st_dt;		
		maint_in.document.form1.che_end_dt.value 	= end_dt;				
	}

//-->
</script>
</body>
</html>
