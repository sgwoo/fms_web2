<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.user_mng.*, acar.car_mst.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//용품	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");
	
	
	from_page = "/fms2/lc_rent/lc_c_c_tint.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정
	function update(st){
		if(st == '1')								window.open("/fms2/lc_rent/lc_c_u_tint1.jsp<%=valus%>", "CHANGE_TINT", "left=100, top=100, width=950, height=650");
		else if(st == 'add_tint_3')	window.open("/fms2/lc_rent/lc_c_u_tint2_add.jsp<%=valus%>&st="+st, "CHANGE_TINT", "left=100, top=100, width=950, height=650");
		else												window.open("/fms2/lc_rent/lc_c_u_tint2.jsp<%=valus%>&st="+st, "CHANGE_TINT", "left=100, top=100, width=950, height=650");
	}
	
	//수정
	function update_add(st){
		window.open("/fms2/lc_rent/lc_c_u_tint2_add.jsp<%=valus%>&st="+st, "CHANGE_TINT", "left=100, top=100, width=950, height=650");
	}	

	//스캔등록
	function scan_file(tint_st, content_code, content_seq){
		window.open("/fms2/car_tint/reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}

	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="tint_st" 	value="">
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>썬팅(측후면/전면)</span>            
            <%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("지점장",user_id)){%>
                &nbsp;<a href="javascript:update('1')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>시공구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){%>측후면<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){%>전면<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>시공하지않음<%}%>
                    </td>
                    <td colspan='2' class='title'>시공업체</td>
                    <td colspan='2' width='37%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>필름선택</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>루마
        		<%}else if(tint1.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint1.getFilm_st().equals("6")){%>고급
        		<%}else{%>기타(<%=tint1.getFilm_st()%>)
        		<%}%>
                    </td>
                    <td rowspan='2' width='7%' class='title'>가시광선<br>투과율</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=tint1.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getFilm_st().equals("2")){%>3M
        		<%}else if(tint2.getFilm_st().equals("3")){%>루마
        		<%}else if(tint2.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint2.getFilm_st().equals("6")){%>고급
        		<%}else{%>기타(<%=tint2.getFilm_st()%>)
        		<%}%>                    
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=tint2.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>비용부담</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getCost_st().equals("1")){%>없음
        		<%}else if(tint1.getCost_st().equals("2")){%>고객
        		<%}else if(tint1.getCost_st().equals("4")){%>당사
        		<%}else if(tint1.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td rowspan='2' width='7%' class='title'>견적반영</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>원
        		<%}else if(tint1.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getCost_st().equals("1")){%>없음
        		<%}else if(tint2.getCost_st().equals("2")){%>고객
        		<%}else if(tint2.getCost_st().equals("4")){%>당사
        		<%}else if(tint2.getCost_st().equals("5")){%>에이전트
        		<%}%>                                           
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>원
        		<%}else if(tint2.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>설치일자</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint1.getSup_est_dt())%>까지 요청함</td>
                    <td rowspan='2' width='7%' class='title'>설치비용</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint1.getTint_amt())%>원 (공급가)</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint2.getSup_est_dt())%>까지 요청함</td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint2.getTint_amt())%>원 (공급가)</td>
                </tr>
                <tr> 
                    <td colspan='2' class='title'>비고</td>
                    <td colspan='4'>&nbsp;
                        <%=tint1.getEtc()%></td>
                </tr>                  
                <%}%>
            </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>        
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>블랙박스</span>     
            <%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("지점장",user_id)){%>
            	<%if(!tint3.getTint_yn().equals("Y") && base.getCar_gu().equals("1") && (car.getOpt().contains("빌트인 캠")||car.getOpt().contains("빌트인캠"))){ %><!-- 20190522 -->
            		- 빌트인캠이 포함된 차량입니다. 상시녹화를 필요로 하는 고객의 요청이 있는 경우에만 기타용품에 등록하세요.  (블랙박스 미제공으로 할인받은 경우는 제외입니다.)
                <%}else{ %>
	                &nbsp;<a href="javascript:update('3')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
                <%} %>
            <%}%>    
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint3.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint3.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint3.getOff_nm()%></td>
                </tr>
                <%if(tint3.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>모델선택</td>
                    <td>&nbsp;
                        <%if(tint3.getModel_st().equals("1")){%>추천모델<%}%>
                        <%if(!tint3.getModel_st().equals("") && !tint3.getModel_st().equals("1")){%>기타선택모델(<%=tint3.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>채널선택</td>
                    <td>&nbsp;
                        <%if(tint3.getChannel_st().equals("1")){%>1채널<%}%>
                        <%if(tint3.getChannel_st().equals("2")){%>2채널<%}%>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint3.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint3.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint3.getCost_st().equals("1")){%>없음
        		<%}else if(tint3.getCost_st().equals("2")){%>고객(전액)
        		<%}else if(tint3.getCost_st().equals("3")){%>고객(일부)
        		<%}else if(tint3.getCost_st().equals("4")){%>당사
        		<%}else if(tint3.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint3.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint3.getEst_m_amt())%>원
        		<%}else if(tint3.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint3.getEtc()%></td>
                </tr>                    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint3.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate2(tint3.getSup_dt())%></td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint3.getTint_amt())%>원 (공급가)</td>
                </tr>            
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <%=tint3.getSerial_no()%></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint3.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint3.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a><br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint3.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    <%	}%>                                 
                    </td>
                </tr>  
                <%}%>                                         
            </table>
	</td>
    </tr>   
    <!--블랙박스 추가설치 20180928-->        
    <%if(!tint3.getTint_no().equals("") && !tint3.getPay_dt().equals("") && AddUtil.parseInt(rs_db.getDay(tint3.getPay_dt(), AddUtil.getDate(4))) > 100 ){%>
    <tr>
        <td align=right>         
            <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
                <input type="button" class="button" id="add_tint" value='추가설치' onclick="javascript:update_add('3');">
            <%}%>            
        </td>
    </tr>    
    <%}%>
    <tr>
	<td>&nbsp;</td>
    </tr>        
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>내비게이션</span>
            <%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("지점장",user_id)){%>
                &nbsp;<a href="javascript:update('4')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint4.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint4.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint4.getOff_nm()%></td>
                </tr>
                <%if(tint4.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint4.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint4.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint4.getCost_st().equals("1")){%>없음
        		<%}else if(tint4.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint4.getCost_st().equals("4")){%>당사
        		<%}else if(tint4.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint4.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint4.getEst_m_amt())%>원
        		<%}else if(tint4.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint4.getSup_est_dt())%>까지 요청함
                    </td>
                </tr> 
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint4.getEtc()%></td>
                </tr>
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate2(tint4.getSup_dt())%></td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint4.getTint_amt())%>원 (공급가)</td>
                </tr>            
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <%=tint4.getSerial_no()%></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint4.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint4.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a><br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint4.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>  
                    
                    <%	}%>                     
                    </td>
                </tr>  
                <%}%>                                         
            </table>
	</td>
    </tr>  
    <!--추가설치 20180928-->        
    <%if(!tint4.getTint_no().equals("") && !tint4.getPay_dt().equals("") && AddUtil.parseInt(rs_db.getDay(tint4.getPay_dt(), AddUtil.getDate(4))) > 100 ){%>
    <tr>
        <td align=right>         
            <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
                <input type="button" class="button" id="add_tint" value='추가설치' onclick="javascript:update_add('4');">
            <%}%>            
        </td>
    </tr>    
    <%}%>            
    <tr>
	<td>&nbsp;</td>
    </tr>        
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>기타용품</span>
            <%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("지점장",user_id)){%>
                &nbsp;<a href="javascript:update('5')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>            
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>상품명</td>
                    <td width='37%' >&nbsp;
                        <%=tint5.getCom_nm()%>&nbsp;<%=tint5.getModel_nm()%></td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint5.getOff_nm()%></td>
                </tr>
                <%if(!tint5.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint5.getCost_st().equals("1")){%>없음
        		<%}else if(tint5.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint5.getCost_st().equals("4")){%>당사
        		<%}else if(tint5.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint5.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint5.getEst_m_amt())%>원
        		<%}else if(tint5.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint5.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                     
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate2(tint5.getSup_dt())%></td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint5.getTint_amt())%>원 (공급가)</td>
                </tr>            
                <%}%>                                         
            </table>
	</td>
    </tr>
<!-- 이동형충전기 추가(2018.04.11) -->
<%if(ej_bean.getJg_g_7().equals("3")){ %>
    <tr>
	<td>&nbsp;</td>
    </tr>        
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>이동형충전기</span>
            <%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("지점장",user_id)){%>
                &nbsp;<a href="javascript:update('6')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint6.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint6.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint6.getOff_nm()%></td>
                </tr>
                <%if(tint6.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint6.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint6.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint6.getCost_st().equals("1")){%>없음
        		<%}else if(tint6.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint6.getCost_st().equals("4")){%>당사
        		<%}else if(tint6.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint6.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint6.getEst_m_amt())%>원
        		<%}else if(tint6.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint6.getSup_est_dt())%>까지 요청함
                    </td>
                </tr> 
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint6.getEtc()%></td>
                </tr>
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate2(tint6.getSup_dt())%></td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint6.getTint_amt())%>원 (공급가)</td>
                </tr>            
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <%=tint6.getSerial_no()%></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint6.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint6.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a><br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint6.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>  
                    
                    <%	}%>                     
                    </td>
                </tr>  
                <%}%>                                         
            </table>
	</td>
    </tr>
<%} %>
                    
    <tr>
	<td>&nbsp;</td>
    </tr> 
    <%
                	int a_amt = 0;
                	int c_amt = 0;
                	int c_est_amt = 0;
                	int e_amt = 0;
                	
                	//당사 분담금
                	if((tint1.getCost_st().equals("1")||tint1.getCost_st().equals("4")) && tint1.getTint_amt()>0) a_amt = a_amt + tint1.getTint_amt();
                	if((tint2.getCost_st().equals("1")||tint2.getCost_st().equals("4")) && tint2.getTint_amt()>0) a_amt = a_amt + tint2.getTint_amt();
                	if((tint3.getCost_st().equals("1")||tint3.getCost_st().equals("4")) && tint3.getTint_amt()>0) a_amt = a_amt + tint3.getTint_amt();
                	if((tint4.getCost_st().equals("1")||tint4.getCost_st().equals("4")) && tint4.getTint_amt()>0) a_amt = a_amt + tint4.getTint_amt();
                	if((tint5.getCost_st().equals("1")||tint5.getCost_st().equals("4")) && tint5.getTint_amt()>0) a_amt = a_amt + tint5.getTint_amt();
                	if((tint6.getCost_st().equals("1")||tint6.getCost_st().equals("4")) && tint6.getTint_amt()>0) a_amt = a_amt + tint6.getTint_amt();

                	//고객 분담금
                	if((tint1.getCost_st().equals("2") || tint1.getCost_st().equals("3")) && tint1.getTint_amt()>0) c_amt = c_amt + tint1.getTint_amt();
                	if((tint2.getCost_st().equals("2") || tint2.getCost_st().equals("3")) && tint2.getTint_amt()>0) c_amt = c_amt + tint2.getTint_amt();
                	if((tint3.getCost_st().equals("2") || tint3.getCost_st().equals("3")) && tint3.getTint_amt()>0) c_amt = c_amt + tint3.getTint_amt();
                	if((tint4.getCost_st().equals("2") || tint4.getCost_st().equals("3")) && tint4.getTint_amt()>0) c_amt = c_amt + tint4.getTint_amt();
                	if((tint5.getCost_st().equals("2") || tint5.getCost_st().equals("3")) && tint5.getTint_amt()>0) c_amt = c_amt + tint5.getTint_amt();
                	if((tint6.getCost_st().equals("2") || tint6.getCost_st().equals("3")) && tint6.getTint_amt()>0) c_amt = c_amt + tint6.getTint_amt();
                	
                	//고객 분담금 - 비용부과
                	if((tint1.getCost_st().equals("2") || tint1.getCost_st().equals("3")) && tint1.getTint_amt()>0 && tint1.getEst_st().equals("Y")) c_est_amt = c_est_amt + tint1.getEst_m_amt();
                	if((tint2.getCost_st().equals("2") || tint2.getCost_st().equals("3")) && tint2.getTint_amt()>0 && tint2.getEst_st().equals("Y")) c_est_amt = c_est_amt + tint2.getEst_m_amt();
                	if((tint3.getCost_st().equals("2") || tint3.getCost_st().equals("3")) && tint3.getTint_amt()>0 && tint3.getEst_st().equals("Y")) c_est_amt = c_est_amt + tint3.getEst_m_amt();
                	if((tint4.getCost_st().equals("2") || tint4.getCost_st().equals("3")) && tint4.getTint_amt()>0 && tint4.getEst_st().equals("Y")) c_est_amt = c_est_amt + tint4.getEst_m_amt();
                	if((tint5.getCost_st().equals("2") || tint5.getCost_st().equals("3")) && tint5.getTint_amt()>0 && tint5.getEst_st().equals("Y")) c_est_amt = c_est_amt + tint5.getEst_m_amt();
                	if((tint6.getCost_st().equals("2") || tint6.getCost_st().equals("3")) && tint6.getTint_amt()>0 && tint6.getEst_st().equals("Y")) c_est_amt = c_est_amt + tint6.getEst_m_amt();
                	
                	//에이전트 분담금
                	if(tint1.getCost_st().equals("5") && tint1.getTint_amt()>0) e_amt = e_amt + tint1.getTint_amt();
                	if(tint2.getCost_st().equals("5") && tint2.getTint_amt()>0) e_amt = e_amt + tint2.getTint_amt();
                	if(tint3.getCost_st().equals("5") && tint3.getTint_amt()>0) e_amt = e_amt + tint3.getTint_amt();
                	if(tint4.getCost_st().equals("5") && tint4.getTint_amt()>0) e_amt = e_amt + tint4.getTint_amt();
                	if(tint5.getCost_st().equals("5") && tint5.getTint_amt()>0) e_amt = e_amt + tint5.getTint_amt();
                	if(tint6.getCost_st().equals("5") && tint6.getTint_amt()>0) e_amt = e_amt + tint6.getTint_amt();


    %>    
    <%if(a_amt+c_amt+e_amt >0 || tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y") || tint3.getTint_yn().equals("Y") || tint4.getTint_yn().equals("Y") || !tint5.getModel_nm().equals("") || tint6.getTint_yn().equals("Y")){%>       
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>비용합계 (공급가)</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' rowspan="3" class='title'>구분</td>
                    <td colspan="5" class='title'>비용분담</td>
                    <td width='18%' rowspan="3" class='title'>합계</td>
                </tr>
                <tr>
                  <td width="13%" rowspan="2" class='title'>당사</td>
                  <td colspan="2" class='title'>고객</td>
                  <td colspan="2" class='title'>에이전시</td>
                </tr>
                <tr>
                  <td width="13%" class='title'>금액</td>
                  <td width="15%" class='title'>비용부과</td>
                  <td width='13%' class='title'>금액</td>
                  <td width='15%' class='title'>비용부과</td>
                </tr>
                <tr> 
                    <td class='title'>분담금액</td>
                    <td align="center"><%=AddUtil.parseDecimal(a_amt)%></td>
                    <td align="center"><%=AddUtil.parseDecimal(c_amt)%></td>
                    <td align="center">월<%=AddUtil.parseDecimal(c_est_amt)%>원 반영</td>
                    <td align="center"><%=AddUtil.parseDecimal(e_amt)%></td>
                    <td align="center">지급수수료에서 공제<br>(지급수수료에 반영)</td>                    
                    <td align="center"><%=AddUtil.parseDecimal(a_amt+c_amt+e_amt)%></td>
                </tr>				
            </table>
	</td>
    </tr>  
    <%}%>     
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	//바로가기
	var s_fm = parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value 	= fm.client_id.value;
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";	

//-->
</script>
</body>
</html>
