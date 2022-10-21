<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*, acar.user_mng.*"%>
<jsp:useBean id="olcBean" class="acar.offls_cmplt.Offls_cmpltBean" scope="page"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id 		= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au 		= request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	if(!ref_dt1.equals("") && ref_dt2.equals("")) ref_dt2 = ref_dt1;
	
	Offls_cmpltBean olcb[] = olcD.getCmplt_lst(dt, ref_dt1, ref_dt2, gubun, gubun1, gubun_nm, brch_id, s_au);
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;	
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	
	float avg_per1 = 0;
	float avg_per2 = 0;
	float avg_per3 = 0;
	float avg_per4 = 0;
	float avg_per5 = 0;
	float avg_per6 = 0;
	float avg_per7 = 0;
	float avg_per8 = 0;	
	float avg_per9 = 0;
	float avg_per10 = 0;	

	//평균재리스잔존가대비율 구하기
	float use_per1 = 0;
	float use_per2 = 0;
	float use_per3 = 0;
	float use_per4 = 0;
	
	float use_cnt1 = 0;
	float use_cnt2 = 0;
	float use_cnt3 = 0;
	float use_cnt4 = 0;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
	
	var checkflag = "false";
	
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}
	
	function on_print(car_mng_id)
	{
	
		var SUBWIN="/acar/off_ls_jh/off_ls_jh_print.jsp?car_mng_id="+car_mng_id;	
		window.open(SUBWIN, "on_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
	}	
	
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<table border=0 cellspacing=0 cellpadding=0 width="3370">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
		<tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=560> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=30 class='title'><input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'></td>
                                <td width=30 class='title' style='height:67'>연번</td>
                                <td width=75 class='title'>차량번호</td>				  
                                <td width=185 class='title'>차명</td>
                                <td width=100 class='title'>경매장</td>				  								
				<td width=70 class='title'>경매일자</td>
                                <td width=70 class='title'>최초등록일</td>	                                			  
                            </tr>
                        </table>
                    </td>		
                    <td class='line' width=2810>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='100' class='title' rowspan="2">소비자가격</td>
                                <td width='100' class='title' rowspan="2">구입가격</td>
                                <td width='100' class='title' rowspan="2">희망가</td>
                                <td width='100'class='title' rowspan="2">예상낙찰가</td>
                                <td colspan="7" class='title'>매각(낙찰)</td>
                                <td width='50' class='title' rowspan="2">차령</td>
				<td width='70' class='title' rowspan="2">주행<br>거리</td>
				<td width='60' class='title' rowspan="2">경매장<br>평점</td>
				<td width='90' class='title' rowspan="2">마지막위치</td>
                                <td width='40' class='title' rowspan="2">사고<br>유무</td>
				<td colspan="2" class='title'>사고수리비</td>
				<td colspan="5" class='title'>매각 수수료</td>
                                <td width='100' class='title' rowspan="2">낙찰자</td>
                                <td width='200' class='title' rowspan="2">선택사양</td>
                                <td width='90' class='title' rowspan="2">선택사양가</td>
                                <td width='60' class='title' rowspan="2">배기량</td>
                                <td width='100' class='title' rowspan="2">연료</td>
                                <td width='100' class='title' rowspan="2">색상</td>
                                <td width='100' class='title' rowspan="2">내장색상</td>
                                <td width='50' class='title' rowspan="2">차종<br>코드</td>
                                <td colspan="2" class='title'>보험</td>
                            </tr>
                            <tr> 								
                                <td width='100' class='title'>낙찰가</td>
                                <td width='70' class='title'>소비자가<br>대비</td>
                                <td width='70'  class='title'>구입가<br>대비</td>				  
                                <td width='80' class='title'>예상낙찰가<br>대비</td>		
                                <td width='100' class='title'>편차금액</td>		
                                <td width='80' class='title'>편차%<br>(예상낙찰가<br>기준)</td>		
                                <td width='70' class='title'>편차%<br>(소비자가<br>기준)</td>		
				<td width='100' class='title'>수리금액</td>
				<td width='70' class='title'>소비자가<br>대비</td>								
                                <td width='100' class='title'>낙찰<br>수수료</td>
                                <td width='70' class='title'>출품<br>수수료</td>
				<td width='70' class='title'>재출품<br>수수료</td>
                                <td width='70' class='title'>반입<br>탁송대금</td>
				<td width='70' class='title'>합계</td>
				<td width='80' class='title'>보험사</td>
				<td width='80' class='title'>청구여부</td>
                            </tr>
                        </table>
                    </td>
	        </tr>
		<%if(olcb.length > 0 ){%>
	        <tr>
                    <td class='line' id='td_con' style='position:relative;' width=560> 
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
                	    <% 	for(int i=0; i< olcb.length; i++){
					olcBean = olcb[i];
					String seq = olcD.getAuction_maxSeq(olcBean.getCar_mng_id());%>
                            <tr> 
                                <td width=30 align='center'><input type="checkbox" name="pr" value="<%=olcBean.getCar_mng_id()%>" ></td>
                                <td width=30 align='center'>
                                    <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("매각관리자",ck_acar_id)){%>
					                <a href="javascript:parent.view_detail_s('<%=auth_rw%>','<%=olcBean.getCar_mng_id()%>','<%=seq%>')"><%=i+1%></a>&nbsp;
				                    <%}else{%>
				  	                <%=i+1%><a href="javascript:on_print('<%=olcBean.getCar_mng_id()%>')">
					                .</a>
				                    <%}%>
                                </td>
                                <td width=75 align='center'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=olcBean.getCar_mng_id()%>','<%=seq%>')">
                                				<%if(olcBean.getA_cnt() < 1 ){//수해경력없음%>
								<%=olcBean.getCar_no()%>
								<%	}else{//수해차량%>			  
								<font color="#ff8200"><%=olcBean.getCar_no()%></font> 						
								<%	}%>                                
                                </a></td>								
                                <td width=185><span title='<%=olcBean.getCar_jnm()+" "+olcBean.getCar_nm()%>'>&nbsp;<%=AddUtil.substringbdot(olcBean.getCar_jnm()+" "+olcBean.getCar_nm(),24)%></span></td>
				<td width=100 align='center'><span title='<%=olaD.getActn_nm(olcBean.getActn_id())%>'><%=AddUtil.substringbdot(olaD.getActn_nm(olcBean.getActn_id()),10)%><%=olcBean.getActn_wh()%></span></td>
				<td width=70 align="center"><%= AddUtil.ChangeDate2(olcBean.getActn_dt()) %></td>
                                <td width=70 align='center'><%=AddUtil.ChangeDate2(olcBean.getInit_reg_dt())%></td>				  
                            </tr>
                            <%	}%>
                            <tr> 
                                <td class='title' rowspan='3' colspan='4'>편차 절대값 반영</td>
                                <td class='title' colspan='4'>합계</td>
                            </tr>
                            <tr> 
                                <td class='title' colspan='4'>평균(평균금액 대 평균금액으로 계산)</td>
                            </tr>                            
                            <tr> 
                                <td class='title' colspan='4'>평균(대비율의 평균)</td>
                            </tr>         
                            <tr> 
                                <td class='title' rowspan='3' colspan='4'>편차 부호 반영</td>
                                <td class='title' colspan='4'>합계</td>
                            </tr>
                            <tr> 
                                <td class='title' colspan='4'>평균(평균금액 대 평균금액으로 계산)</td>
                            </tr>                            
                            <tr> 
                                <td class='title' colspan='4'>평균(대비율의 평균)</td>
                            </tr>                                   
                        </table>
                    </td>
                    <td class='line' width=2810>
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
                            <%	int vt_size = olcb.length;
                            
                            	for(int i=0; i< olcb.length; i++){
					olcBean = olcb[i];
			
					int cSum 	= olcBean.getCar_cs_amt() + olcBean.getCar_cv_amt() + olcBean.getOpt_cs_amt() + olcBean.getOpt_cv_amt() + olcBean.getClr_cs_amt() + olcBean.getClr_cv_amt();
					int fSum 	= olcBean.getCar_fs_amt() + olcBean.getCar_fv_amt() + olcBean.getSd_cs_amt()  + olcBean.getSd_cv_amt()  - olcBean.getDc_cs_amt()  - olcBean.getDc_cv_amt();
					
					double hppr 		= olcBean.getHppr();
					double nakpr 		= olcBean.getNak_pr();
					double o_s_amt 		= olcBean.getO_s_amt();
					double hp_s_cha_amt	= olcBean.getHp_s_cha_amt();
					double hp_accid_amt	= olcBean.getHp_accid_amt();
					
					double hp_c_per 	= (nakpr*100)/cSum;
					double hp_f_per 	= (nakpr*100)/fSum;
					double hp_s_per 	= 0;
					double hp_s_cha_per 	= 0;
					double hp_c_cha_per 	= 0;
					double abs_hp_s_cha_per = 0;
					double abs_hp_c_cha_per = 0;
					double hp_accid_c_per 	= 0;
					//편차금액 절대값
					double abs_hp_s_cha_amt = 0;
					long   l_abs_hp_s_cha_amt = 0;
					
					if(o_s_amt>0){
						abs_hp_s_cha_amt = olcBean.getHp_s_cha_amt()>0?olcBean.getHp_s_cha_amt():-olcBean.getHp_s_cha_amt();
						l_abs_hp_s_cha_amt = olcBean.getHp_s_cha_amt()>0?olcBean.getHp_s_cha_amt():-olcBean.getHp_s_cha_amt();
						hp_s_per 	= (nakpr*100)/o_s_amt;
						hp_s_cha_per 	= (hp_s_cha_amt*100)/o_s_amt;
						hp_c_cha_per 	= (hp_s_cha_amt*100)/cSum;
						abs_hp_s_cha_per= (abs_hp_s_cha_amt*100)/o_s_amt;
						abs_hp_c_cha_per= (abs_hp_s_cha_amt*100)/cSum;
						
						
						
					}
					if(hp_accid_amt>0){
						hp_accid_c_per 	= (hp_accid_amt*100)/cSum;
					}
					
					float use_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_s_per),2));
								
					if(olcBean.getActn_id().equals("000502")){//시화-현대글로비스(주)
						use_cnt1++;
						use_per1 = use_per1 + use_per;
					}else if(olcBean.getActn_id().equals("013011")){//분당-현대글로비스(주)
						use_cnt2++;
						use_per2 = use_per2 + use_per;
					}else if(olcBean.getActn_id().equals("022846")){//동화엠파크 013222-> 20150515 (주)케이티렌탈 022846
						use_cnt3++;
						use_per3 = use_per3 + use_per;
					}else if(olcBean.getActn_id().equals("011723")||olcBean.getActn_id().equals("020385")){//(주)서울자동차경매 -> 에이제이셀카 주식회사
						use_cnt4++;
						use_per4 = use_per4 + use_per;
					}	
					
										
					total_amt1 	= total_amt1  + AddUtil.parseLong(String.valueOf(cSum));	
					total_amt2 	= total_amt2  + AddUtil.parseLong(String.valueOf(fSum));			
					total_amt3 	= total_amt3  + AddUtil.parseLong(String.valueOf(olcBean.getO_s_amt()));
					total_amt4 	= total_amt4  + AddUtil.parseLong(String.valueOf(olcBean.getHppr()));
					total_amt5 	= total_amt5  + AddUtil.parseLong(String.valueOf(olcBean.getNak_pr()));										
					total_amt6 	= total_amt6  + AddUtil.parseLong(String.valueOf(olcBean.getComm1_tot()));
					total_amt7 	= total_amt7  + AddUtil.parseLong(String.valueOf(olcBean.getComm2_tot()));
					total_amt8 	= total_amt8  + AddUtil.parseLong(String.valueOf(olcBean.getComm3_tot()));
					total_amt9 	= total_amt9  + AddUtil.parseLong(String.valueOf(olcBean.getComm_tot()));				
					total_amt10	= total_amt10 + AddUtil.parseLong(String.valueOf(olcBean.getOut_amt()));					
					total_amt11	= total_amt11 + AddUtil.parseLong(String.valueOf(olcBean.getHp_accid_amt()));					
					total_amt12	= total_amt12 + AddUtil.parseLong(String.valueOf(l_abs_hp_s_cha_amt));
					total_amt13	= total_amt13 + AddUtil.parseLong(String.valueOf(olcBean.getHp_s_cha_amt()));
					
					total_amt15	= total_amt15 + AddUtil.parseLong(String.valueOf(olcBean.getKm()));
					total_amt16	= total_amt16 + AddUtil.parseLong(String.valueOf(olcBean.getOpt_cs_amt()+olcBean.getOpt_cv_amt()));
					
					avg_per1 = avg_per1 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_c_per),2));
					avg_per2 = avg_per2 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_f_per),2));
					avg_per3 = avg_per3 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_s_per),2));
					avg_per4 = avg_per4 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(abs_hp_s_cha_per),2));
					avg_per5 = avg_per5 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(abs_hp_c_cha_per),2));
					avg_per6 = avg_per6 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_s_cha_per),2));
					avg_per7 = avg_per7 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_c_cha_per),2));
					avg_per8 = avg_per8 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_accid_c_per),2));
					
					avg_per9 = avg_per9 + AddUtil.parseFloat(AddUtil.parseFloatCipher(olcBean.getCar_old_mons(),1));
					
										

			    %>
                            <tr>                  
                                <td width=100 align='right'><%=AddUtil.parseDecimal(cSum)%></td>
                                <td width=100 align='right'><%=AddUtil.parseDecimal(fSum)%></td>
                                <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getHppr())%></td>
                                <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getO_s_amt())%></td>							  							                                  
                                <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getNak_pr())%></td>
                                <td width=70 align='right'><%=AddUtil.parseFloatCipher(String.valueOf(hp_c_per),2)%>%</td>
                                <td width=70 align='right'><%=AddUtil.parseFloatCipher(String.valueOf(hp_f_per),2)%>%</td>							  
                                <td width=80 align='right'><%=AddUtil.parseFloatCipher(String.valueOf(hp_s_per),2)%>%</td>	
                                <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getHp_s_cha_amt())%></td>
                                <td width=80 align='right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(hp_s_cha_per)),2)%>%</td>
                                <td width=70 align='right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(hp_c_cha_per)),2)%>%</td>                                
                                <td width=50 align='center'><%=olcBean.getCar_old_mons()%></td>
                                <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getKm())%><%if(olcBean.getKm().equals("")){%><%=AddUtil.parseDecimal(olcBean.getToday_dist())%><%}%></td>
                                <td width=60 align='center'><%=olcBean.getActn_jum()%></td>
                                <td width=90 align='center'><%=olcBean.getPark_nm()%></td>
                                <td width=40 align='center'><%if(olcBean.getAccident_yn().equals("1")){%>유<%}else{%>-<%}%></td>							  
                                <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getHp_accid_amt())%></td>
                                <td width=70 align='right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(hp_accid_c_per)),2)%>%</td>                                                                
			        <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getComm1_tot())%></td><!-- 낙찰수수료 -->
                                <td width=70 align='right'><%if(AddUtil.parseDecimal(olcBean.getOut_amt()).equals("0")||AddUtil.parseDecimal(olcBean.getOut_amt()).equals("")||AddUtil.parseDecimal(olcBean.getOut_amt()).equals("null")){%><%=AddUtil.parseDecimal(olcBean.getComm2_tot())%><%}else{%>0<%}%></td><!--출품-->
			        <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getOut_amt())%></td><!--재출품-->
                                <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getComm3_tot())%></td>							  
			        <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getComm_tot())%></td>							  							  			        
                                <td width=100 align='center'><span title='<%=olcBean.getSui_nm()%>'><%=AddUtil.subData(olcBean.getSui_nm(),6)%></span></td>				  
                                <td width=200 align='center'><span title='<%=olcBean.getOpt()%>'><%=AddUtil.subData(olcBean.getOpt(), 6)%></span></td>
                                <td width=90 align='right'><%=AddUtil.parseDecimal(olcBean.getOpt_cs_amt()+olcBean.getOpt_cv_amt())%></td>							  
                                <td width=60 align='center'><%=AddUtil.parseDecimal(olcBean.getDpm())%></td>
                                <td width=100 align='center'><%=c_db.getNameByIdCode("0039", "", olcBean.getFuel_kd())%></td>
                                <td width=100 align='center' ><span title='<%=olcBean.getColo()%>'><%=AddUtil.subData(olcBean.getColo(),6)%></span></td>
                                <td width=100 align='center' ><span title='<%=olcBean.getIn_col()%>'><%=AddUtil.subData(olcBean.getIn_col(),6)%></span></td>
                                <td width='50' align='center'><%=olcBean.getJg_code()%></td>
                                <td width='80' align='center'><span title='<%=olcBean.getIns_com_nm()%>'><%=AddUtil.substringbdot(olcBean.getIns_com_nm(),10)%></span></td>
                                <td width='80' align='center'><span title="<% if(!olcBean.getReq_dt().equals("")) out.print(AddUtil.ChangeDate2(olcBean.getReq_dt())); %>"><% if(olcBean.getReq_dt().equals("")) out.print("<font color=red>미청구</font>"); else out.print("청구"); %></span></td>
                            </tr>				
                            <%}%>
			    <tr> 
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt5)%></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt12)%></td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt11)%></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt6)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt7)%></td>				
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt10)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt8)%></td>            		        
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt9)%></td>            		                    		        
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt16)%></td>
                                <td class='title' colspan='7'>&nbsp;</td>
			    </tr>
			    <tr> 
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt1/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt2/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt4/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt3/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt5/vt_size)))%></td>            		        
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt2))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt12/vt_size)))%></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt12))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt12))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt11/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt11))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt6/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt7/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt10/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt8/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt9/vt_size)))%></td>
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt16/vt_size)))%></td>
                                <td class='title' colspan='7'>&nbsp;</td>
			    </tr>		
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per1/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per2/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per3/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per4/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per5/vt_size,2)%>%</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per8/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='7'>&nbsp;</td>
			    </tr>	
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt13)%></td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>            		                    		        
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='7'>&nbsp;</td>
			    </tr>
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt13/vt_size)))%></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt13))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt13))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='7'>&nbsp;</td>
			    </tr>		
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per6/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per7/vt_size,2)%>%</td>
				<td class='title'><%=AddUtil.parseFloatCipher(avg_per9/vt_size,1)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt15/vt_size)))%></td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='7'>&nbsp;</td>
			    </tr>	
                        </table>
                    </td>
	        </tr>
                <%}else{%>
	        <tr>
	            <td class='line' id='td_con' style='position:relative;' width=560> 
	                <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	            <td class='line' width=2810> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 차량이 없읍니다.</td>
                            </tr>          
                        </table>
		    </td>
	        </tr>
                <%}%>		
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	parent.document.form1.avg_per1.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per1/use_cnt1), 2)%>';
	parent.document.form1.avg_per2.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per2/use_cnt2), 2)%>';
	parent.document.form1.avg_per3.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per3/use_cnt3), 2)%>';
	parent.document.form1.avg_per4.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per4/use_cnt4), 2)%>';
//-->
</script>
</body>
</html>