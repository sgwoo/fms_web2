<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.car_register.*,acar.car_mst.*, acar.offls_pre.*, acar.secondhand.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String st = request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun = request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	String q_sort_nm = request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");	
	String q_sort = request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
%>

<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));
	
	if(rent_l_cd.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
	}
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	
	//차량번호 이력
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	String white = "white";	
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);
	
	//차량정보
	Off_ls_pre_apprsl ap_bean = rs_db.getCarBinImg2(car_mng_id);
	
	//차량정보
	Hashtable res = rs_db.getCarInfo(car_mng_id);
	
	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();
	
	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
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
			theURL = '/agent/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();
	}

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//스캔한 등록증 보기
	function view_scanfile(path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		
	
	//예약이력	
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";  	
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes"); 		
	}
			
//-->
</script>
</head>
<body leftmargin="15">

<form action="register_null_ui.jsp" name="CarRegForm" method="POST" >
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rpt_no" value="<%=rpt_no%>">
<input type="hidden" name="firm_nm" value="<%=firm_nm%>">
<input type="hidden" name="client_nm" value="<%=client_nm%>">
<input type="hidden" name="imm_amt" value="<%=imm_amt%>">
<input type="hidden" name="car_name" value="<%=mst.getCar_name()%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="reg_dt" value="<%=Util.getDate()%>">
<input type="hidden" name="reg_nm" value="<%=c_db.getNameById(user_id, "USER")%>">
<input type="hidden" name="acq_std" value="<%=cr_bean.getAcq_std()%>">
<input type="hidden" name="acq_acq" value="<%=cr_bean.getAcq_acq()%>">
<input type="hidden" name="acq_f_dt" value="<%=cr_bean.getAcq_f_dt()%>">
<input type="hidden" name="acq_ex_dt" value="<%=cr_bean.getAcq_ex_dt()%>">
<input type="hidden" name="acq_re" value="<%=cr_bean.getAcq_re()%>">
<input type="hidden" name="acq_is_p" value="<%=cr_bean.getAcq_is_p()%>">
<input type="hidden" name="acq_is_o" value="<%=cr_bean.getAcq_is_o()%>">
<input type="hidden" name="mort_st" value="<%=cr_bean.getMort_st()%>">
<input type="hidden" name="mort_dt" value="<%=cr_bean.getMort_dt()%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>자동차 상세내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>최초등록일</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%=cr_bean.getInit_reg_dt()%>" size="10" class=whitetext  maxlength="10">
                    </td>
                    <td class=title width=12%>지역</td>
                    <td width=21%>&nbsp; 
                    	<%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%>
                    </td>
                    <td class=title width=12%>관리번호</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="car_doc_no" value="<%=cr_bean.getCar_doc_no()%>" size="10" class=whitetext  maxlength="10">
                    </td>					
                </tr>
                <tr> 
                    <td class=title>자동차관리번호</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" value="<%=cr_bean.getCar_no()%>" size="15" class=whitetext maxlength="15">
                    </td>
                    <td class=title>차종</td>
                    <td>&nbsp; 
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getFuel_kd())%>                      
                    </td>
                    <td class=title>용도</td>
                    <td>&nbsp; 
                      <select name="car_use" disabled>
                        <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>영업용</option>
                        <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>자가용</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                    <%=mst.getCar_nm()%> <%=mst.getCar_name()%> 
                                      <input type="hidden" name="car_nm" value="<%=mst.getCar_nm()%>">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=title>형식</td>
                    <td>&nbsp; 
                      <input type="text" name="car_form" value="<%=cr_bean.getCar_form()%>" size="15" class=whitetext>
                    </td>
                    <td class=title>연식</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차대번호</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=cr_bean.getCar_num()%>" size="20" class=whitetext maxlength="20">
                    </td>
                    <td class=title>원동기형식</td>
                    <td>&nbsp; 
                      <input type="text" name="mot_form" value="<%=cr_bean.getMot_form()%>" size="30" class=whitetext>
                    </td>
                    <td class=title>GPS장치</td>
                    <td>&nbsp; 
                      <%if(cr_bean.getGps().equals("Y")){%>장착<%}else{%>미장착<%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>기본사양</td>
                    <td colspan='5'>&nbsp; 
                      <%=res.get("CAR_B")%>
                    </td>
                </tr>                
                <tr> 
                    <td class=title>선택사양</td>
                    <td colspan='5'>&nbsp; 
                      <%=res.get("OPT")%>
                    </td>
                </tr>    
                <tr> 
                    <td class=title>차량현위치</td>
                    <td colspan='3'>&nbsp; 
                      <SELECT NAME="park" disabled>
							<%for(int i = 0 ; i < good_size ; i++){
								CodeBean good = goods[i];%>
							<option value='<%= good.getNm_cd()%>' <%if(res.get("PARK").equals(good.getNm_cd()))%> selected<%%>><%= good.getNm()%></option>
							<%}%>                 		         				
        		        </SELECT>
						<%=res.get("PARK_CONT")%>
						(보유차 당시 최종데이타)
                    </td>
                    <td class=title>색상</td>
                    <td>&nbsp; 
                      <%=res.get("COLO")%>
                    </td>
                    
                </tr>                            
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재원</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>
                    <td class=title width=13%>배기량</td>
                    <td width=15%>&nbsp;
                      <%=cr_bean.getDpm()%> cc </td>
                    <td class=title width=10%>승차정원</td>
                    <td>&nbsp;
                      <%=cr_bean.getTaking_p()%> 명 </td>
                    <td class=title width=10%>길이</td>
                    <td width=15%>&nbsp; 
                      <%=cr_bean.getCar_length()%> mm </td>
                    <td class=title width=10%>너비</td>
                    <td width=15%>&nbsp; 
                      <%=cr_bean.getCar_width()%> mm </td>                       
                </tr>
                <tr>
                    <td class=title>연료의종류</td>
                    <td colspan="3">&nbsp;
                      <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>
                      (연비: <%=cr_bean.getConti_rat()%> km/L) &nbsp; </td>
                    <td class=title>타이어</td>
                    <td>&nbsp;
                      <%=cr_bean.getTire()%>
                    </td>  
        			<td class=title>최대적재량</td>
                    <td>&nbsp;
                      <%=cr_bean.getMax_kg()%> kg
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>비고</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>검사유효기간</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=cr_bean.getMaint_st_dt()%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=cr_bean.getMaint_end_dt()%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title width=12%>일반성보증</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="guar_gen_y" value="<%=cr_bean.getGuar_gen_y()%>" size="4" class=whitetext>
                      년 
                      <input type="text" name="guar_gen_km" value="<%=cr_bean.getGuar_gen_km()%>" size="8" class=whitetext>
                      km </td>
                    <td class=title width=12%>내구성보증</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="guar_endur_y" value="<%=cr_bean.getGuar_endur_y()%>" size="4" class=whitetext>
                      년 
                      <input type="text" name="guar_endur_km" value="<%=cr_bean.getGuar_endur_km()%>" size="8" class=whitetext>
                      km </td>
                </tr>
                <tr> 
                    <td class=title>최초등록번호</td>
                    <td>&nbsp; 
                      <input type="text" name="first_car_no" value="<%=cr_bean.getFirst_car_no()%>" size="15" class=whitetext  maxlength="15">
                    </td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=cr_bean.getCar_end_dt()%>" size="10" class=whitetext>
                    </td>
                    <td class=title>점검유효기간</td>
                    <td>&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>예비키</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td width=20% class=title>보유여부</td>
                    <td colspan="4" >&nbsp; <input type="radio" name="key_yn" value="Y" <%if(CarKeyBn.getKey_yn().equals("Y"))%>checked<%%>>
                      유 
                      <input type="radio" name="key_yn" value="N" <%if(CarKeyBn.getKey_yn().equals("N"))%>checked<%%>>
                      무 </td>
                </tr>
                <tr id=tr_y1 style="display:<%if(CarKeyBn.getKey_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
                    <td width=20% class=title>일반보조키</td>
                    <td width=20% class=title>카피보조키</td>
                    <td width=20% class=title>리모콘</td>
                    <td width=20% class=title>스마트키</td>
                    <td width=20% class=title>기타( 
                      <input type="text" name="key_kd5_nm" value="<%=CarKeyBn.getKey_kd5_nm()%>" size="15" class=<%=white%>text>
                      )</td>
                </tr>
                <tr id=tr_y2 style="display:<%if(CarKeyBn.getKey_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
                    <td align="center"><input type="text" name="key_kd1" value="<%=CarKeyBn.getKey_kd1()%>" size="3" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd2" value="<%=CarKeyBn.getKey_kd2()%>" size="3" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd3" value="<%=CarKeyBn.getKey_kd3()%>" size="3" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd4" value="<%=CarKeyBn.getKey_kd4()%>" size="3" class=<%=white%>num>
                      개</td>
                    <td align="center"><input type="text" name="key_kd5" value="<%=CarKeyBn.getKey_kd5()%>" size="3" class=<%=white%>num>
                      개</td>
                  </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 이력</span></td>
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
        			<%if(!ch_bean.getScanfile().equals("")){%>
					<%		if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:view_scanfile('<%=ch_bean.getScanfile()%>');"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%		}else{%>
    			    <a href="javascript:ScanOpen('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
					<%		}%>					
        			<%}%>		
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
        <td align="center">
	    <%if(ap_bean.getImgfile1().equals("")){%> 
	    <%}else{%>
	    <a href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=cr_bean.getCar_mng_id()%>','ImgAdd','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50');" class="btn"><img src=/acar/images/center/button_see_p.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    <%}%>
	    <%if(srh_size>0){%>
	    &nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="재리스상담 이력"><img src=/acar/images/center/button_cons_slease.gif border=0 align=absmiddle></a>&nbsp;(<%=srh_size%>건)
	    <%}%>	    
	    &nbsp;&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>