<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=off_ls_cmplt_excel_list.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
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

	//?????????????????????? ??????
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

</head>

<body>
<table border=0 cellspacing=0 cellpadding=0 width="3180">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
		<tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width=100%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>                                 
                                <td width=30 class='title'  rowspan="2">????</td>
                                <td width=75 class='title' rowspan="2">????????</td>				  
                                <td width=185 class='title' rowspan="2">????</td>
                                <td width=100 class='title' rowspan="2">??????</td>				  								
				<td width=70 class='title' rowspan="2">????????</td>
                                <td width=70 class='title' rowspan="2">??????????</td>				  
                                <td width='100' class='title' rowspan="2">??????????</td>
                                <td width='100' class='title' rowspan="2">????????</td>
                                <td width='100' class='title' rowspan="2">??????</td>
                                <td width='100'class='title' rowspan="2">??????????</td>
                                <td colspan="7" class='title'>????(????)</td>
                                <td width='50' class='title' rowspan="2">????</td>
				<td width='70' class='title' rowspan="2">????<br>????</td>
				<td width='60' class='title' rowspan="2">??????<br>????</td>
				<td width='90' class='title' rowspan="2">??????????</td>
                                <td width='40' class='title' rowspan="2">????<br>????</td>
				<td colspan="2" class='title'>??????????</td>
				<td colspan="5" class='title'>???? ??????</td>
                                <td width='100' class='title' rowspan="2">??????</td>
                                <td width='200' class='title' rowspan="2">????????</td>
                                <td width='90' class='title' rowspan="2">??????????</td>
                                <td width='60' class='title' rowspan="2">??????</td>
                                <td width='100' class='title' rowspan="2">????</td>
                                <td width='100' class='title' rowspan="2">????</td>
                                <td width='100' class='title' rowspan="2">????????</td>
                                <td width='50' class='title' rowspan="2">????<br>????</td>
                            </tr>
                            <tr> 								
                                <td width='100' class='title'>??????</td>
                                <td width='70' class='title'>????????<br>????</td>
                                <td width='70'  class='title'>??????<br>????</td>				  
                                <td width='80' class='title'>??????????<br>????</td>		
                                <td width='100' class='title'>????????</td>		
                                <td width='80' class='title'>????%<br>(??????????<br>????)</td>		
                                <td width='70' class='title'>????%<br>(????????<br>????)</td>		
				<td width='100' class='title'>????????</td>
				<td width='70' class='title'>????????<br>????</td>								
                                <td width='100' class='title'>????<br>??????</td>
                                <td width='70' class='title'>????<br>??????</td>
				<td width='70' class='title'>??????<br>??????</td>
                                <td width='70' class='title'>????<br>????????</td>
				<td width='70' class='title'>????</td>
                            </tr>
		<%if(olcb.length > 0 ){%>
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
					//???????? ??????
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
								
					if(olcBean.getActn_id().equals("000502")){//????-????????????(??)
						use_cnt1++;
						use_per1 = use_per1 + use_per;
					}else if(olcBean.getActn_id().equals("013011")){//????-????????????(??)
						use_cnt2++;
						use_per2 = use_per2 + use_per;
					}else if(olcBean.getActn_id().equals("022846")){//?????????? 013222-> 20150515 (??)?????????? 022846
						use_cnt3++;
						use_per3 = use_per3 + use_per;
					}else if(olcBean.getActn_id().equals("011723")||olcBean.getActn_id().equals("020385")){//(??)?????????????? -> ???????????? ????????
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
                                <td width=30 align='center'><%=i+1%></td>
                                <td width=75 align='center'>
                                				<%if(olcBean.getA_cnt() < 1 ){//????????????%>
								<%=olcBean.getCar_no()%>
								<%	}else{//????????%>			  
								<font color="#ff8200"><%=olcBean.getCar_no()%></font> 						
								<%	}%>                                
                                </td>								
                                <td width=185><%=olcBean.getCar_jnm()+" "+olcBean.getCar_nm()%></td>
				<td width=100 align='center'><%=olaD.getActn_nm(olcBean.getActn_id())%><%=olcBean.getActn_wh()%></td>
				<td width=70 align="center"><%= AddUtil.ChangeDate2(olcBean.getActn_dt()) %></td>
                                <td width=70 align='center'><%=AddUtil.ChangeDate2(olcBean.getInit_reg_dt())%></td>				  
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
                                <td width=40 align='center'><%if(olcBean.getAccident_yn().equals("1")){%>??<%}else{%>-<%}%></td>							  
                                <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getHp_accid_amt())%></td>
                                <td width=70 align='right'><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(hp_accid_c_per)),2)%>%</td>                                                                
			        <td width=100 align='right'><%=AddUtil.parseDecimal(olcBean.getComm1_tot())%></td><!-- ?????????? -->
                                <td width=70 align='right'><%if(AddUtil.parseDecimal(olcBean.getOut_amt()).equals("0")||AddUtil.parseDecimal(olcBean.getOut_amt()).equals("")||AddUtil.parseDecimal(olcBean.getOut_amt()).equals("null")){%><%=AddUtil.parseDecimal(olcBean.getComm2_tot())%><%}else{%>0<%}%></td><!--????-->
			        <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getOut_amt())%></td><!--??????-->
                                <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getComm3_tot())%></td>							  
			        <td width=70 align='right'><%=AddUtil.parseDecimal(olcBean.getComm_tot())%></td>							  							  			        
                                <td width=100 align='center'><%=olcBean.getSui_nm()%></td>				  
                                <td width=200 align='center'><%=olcBean.getOpt()%></td>
                                <td width=90 align='right'><%=AddUtil.parseDecimal(olcBean.getOpt_cs_amt()+olcBean.getOpt_cv_amt())%></td>							  
                                <td width=60 align='center'><%=AddUtil.parseDecimal(olcBean.getDpm())%></td>
                                <td width=100 align='center'><%=c_db.getNameByIdCode("0039", "", olcBean.getFuel_kd())%></td>
                                <td width=100 align='center' ><%=olcBean.getColo()%></td>
                                <td width=100 align='center' ><%=olcBean.getIn_col()%></td>
                                <td width='50' align='center'><%=olcBean.getJg_code()%></td>                                
                            </tr>
                            
                            <%	}%>
                            <tr> 
                                <td class='title' rowspan='3' colspan='3'>???? ?????? ????</td>
                                <td class='title' colspan='3'>????</td>
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
                                <td class='title' colspan='5'>&nbsp;</td>                                
                            </tr>
                            <tr> 
                                <td class='title' colspan='3'>????(???????? ?? ???????????? ????)</td>
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
                                <td class='title' colspan='5'>&nbsp;</td>                                
                            </tr>                            
                            <tr> 
                                <td class='title' colspan='3'>????(???????? ????)</td>
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
                                <td class='title' colspan='5'>&nbsp;</td>                                
                            </tr>         
                            <tr> 
                                <td class='title' rowspan='3' colspan='3'>???? ???? ????</td>
                                <td class='title' colspan='3'>????</td>
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
                                <td class='title' colspan='5'>&nbsp;</td>                                
                            </tr>
                            <tr> 
                                <td class='title' colspan='3'>????(???????? ?? ???????????? ????)</td>
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
                                <td class='title' colspan='5'>&nbsp;</td>                                
                            </tr>                            
                            <tr> 
                                <td class='title' colspan='3'>????(???????? ????)</td>
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
                                <td class='title' colspan='5'>&nbsp;</td>                                
                            </tr>                                                               
                        </table>
                    </td>
	        </tr>
                <%}%>		
            </table>
        </td>
    </tr>
</table>
</body>
</html>