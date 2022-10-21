<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	//기초정보
	if(!c_id.equals("")){//값이 있을때 검색한다.		
		rl_bean = fdb.getCarRent(c_id, m_id, l_cd);
	}		
	
	//과태료정보
	if(!c_id.equals("") && !seq_no.equals("")){//값이 있을때 검색한다.			
		f_bean = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd, seq_no);	
	}
	
	//과태료 이의신청공문
	if(!c_id.equals("") && !seq_no.equals("")){//값이 있을때 검색한다.			
		FineDocListBn = FineDocDb.getFineDocList(c_id, seq_no, m_id, l_cd);
		if(!FineDocListBn.getDoc_id().equals("")){
			FineDocBn = FineDocDb.getFineDoc(FineDocListBn.getDoc_id());
		}
		FineGovBn = FineDocDb.getFineGov(f_bean.getPol_sta());
	}
				
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	String content_code = "FINE";
	String content_seq  = m_id+l_cd+c_id+seq_no;
	
	Vector attach_vt = attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_type2 = "";
	String seq2 = "";
	String file_type3 = "";
	String seq3 = "";
	String file_name1 = "";
	String file_name2 = "";
	String file_name3 = "";
	String file_size3 = "";
	
	if(attach_vt_size >0){
		for(int i=0; i< attach_vt.size(); i++){
	    	Hashtable ht = (Hashtable)attach_vt.elementAt(i);   
			
			if((content_seq+1).equals(ht.get("CONTENT_SEQ"))){
				file_name1 = String.valueOf(ht.get("FILE_NAME"));
				file_type1 = String.valueOf(ht.get("FILE_TYPE"));
				seq1 = String.valueOf(ht.get("SEQ"));
				
			}else if((content_seq+2).equals(ht.get("CONTENT_SEQ"))){
				file_name2 = String.valueOf(ht.get("FILE_NAME"));
				file_type2 = String.valueOf(ht.get("FILE_TYPE"));
				seq2 = String.valueOf(ht.get("SEQ"));
				
			}else if((content_seq+3).equals(ht.get("CONTENT_SEQ"))){
				file_name3 = String.valueOf(ht.get("FILE_NAME"));
				file_type3 = String.valueOf(ht.get("FILE_TYPE"));
				seq3 = String.valueOf(ht.get("SEQ"));
				file_size3 = String.valueOf(ht.get("FILE_SIZE"));
			}
		}	
	}

%>
<form action="" name="form1" method="POST" >
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <%if(!f_bean.getRent_s_cd().equals("")){//예약시스템 등록 차량이면
		//단기계약정보
		RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), c_id);
		//고객정보
		RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
		String rent_st = rc_bean.getRent_st();
		if(rent_st.equals("1"))			rent_st = "단기대여";
		else if(rent_st.equals("2"))	rent_st = "정비대차";
		else if(rent_st.equals("3"))	rent_st = "사고대차";
		else if(rent_st.equals("4"))	rent_st = "업무대여";
		else if(rent_st.equals("5"))	rent_st = "업무지원";
		else if(rent_st.equals("6"))	rent_st = "차량정비";
		else if(rent_st.equals("7"))	rent_st = "차량점검";
		else if(rent_st.equals("8"))	rent_st = "정비대차";
		else if(rent_st.equals("9"))	rent_st = "보험대차";
		else if(rent_st.equals("10"))	rent_st = "지연대차";
		else if(rent_st.equals("12"))	rent_st = "월렌트";
	%>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차 : <a href="javascript:CarResSearch()">예약시스템</a></span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title width="15%">상호</td>
                    <td width="32%">&nbsp;<input type="text" name="res_firm" value="<%=rc_bean2.getFirm_nm()%>" size="30" readonly>
                    </td>
                    <td class=title width="16%">성명</td>
                    <td width="37%">&nbsp;<input type="text" name="res_client" value="<%=rc_bean2.getCust_nm()%>" size="30" readonly>
                    </td>
                </tr>
                <tr>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<input type="text" name="res_st" value="<%=rent_st%>" size="30" class=whitetext readonly>
                    </td>
                    <td class=title>대여기간</td>
                    <td>&nbsp;<input type="text" name="res_sdt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>" size="10" class=whitetext readonly>
                    ~
                      <input type="text" name="res_edt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>" size="10" class=whitetext readonly>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <%}%>
    <tr>
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사실확인 및 이의제기</span></td>
        <td align="right"><img src=/acar/images/center/arrow_ddj.gif align=absmiddle><font color="#999999"> : 김태연
            <%if(!f_bean.getFine_st().equals("")){%>
        &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : 
        <input type="text" name="update_id" size="6" value="<%=c_db.getNameById(f_bean.getUpdate_id(), "USER")%>" class=white readonly>
        &nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : 
        <input type="text" name="update_dt" size="10" value="<%=AddUtil.ChangeDate2(f_bean.getUpdate_dt())%>" class=white readonly>
        <%}%>
        </font></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td class=line colspan="2">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title width="15%">구분</td>
                    <td width="32%">&nbsp;<select name="fine_st" disabled>
                        <option value="1" <%if(f_bean.getFine_st().equals("1"))%>selected<%%>>과태료</option>
                        <option value="2" <%if(f_bean.getFine_st().equals("2"))%>selected<%%>>범칙금</option>
                      </select>
                    </td>
                    <td class=title width="16%">사실확인 접수일자</td>
                    <td width="37%">&nbsp;<input type="text" name="notice_dt" value="<%if(seq_no.equals("") && f_bean.getNotice_dt().equals("")) {%><%=AddUtil.getDate()%><%}else{%><%=AddUtil.ChangeDate2(f_bean.getNotice_dt())%><%}%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class=title>고지서번호</td>
                    <td>&nbsp;<input type="text" name="paid_no" value="<%=f_bean.getPaid_no()%>" size="30" class=whitetext style='IME-MODE: inactive'></td>
                    <td class=title>위반장소</td>
                    <td>&nbsp;<input type="text" name="vio_pla" value="<%=f_bean.getVio_pla()%>" size="30" class=whitetext maxlength="50" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class=title>위반일시</td>
                    <td>&nbsp;<input type="text" name="vio_ymd" value="<%=AddUtil.ChangeDate2(f_bean.getVio_dt().substring(0,8))%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type="text" name="vio_s" value="<%=f_bean.getVio_dt().substring(8,10)%>" size="2" maxlength=2 class=whitetext >
                    시
                    <input type="text" name="vio_m" value="<%=f_bean.getVio_dt().substring(10,12)%>" size="2" maxlength=2 class=whitetext >
                    분
                    </td>
                    <td class=title>위반내용</td>
                    <td>&nbsp;<input type="text" name="vio_cont" value="<%=f_bean.getVio_cont()%>" size="30" class=whitetext onBlur="javascript:set_paid_amt()" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class=title>청구기관</td>
                    <td>&nbsp;<input name="gov_nm" type="text" class=whitetext value="<%if(FineGovBn.getGov_nm().equals("")){%><%=f_bean.getPol_sta()%><%}else{%><%=FineGovBn.getGov_nm()%><%}%>" size="30" maxlength="50" style='IME-MODE: active' onKeyDown='javascript:enter()'>
                        <input type='hidden' name="mng_dept" value=''>
                        <input type='hidden' name="gov_id" value='<%=f_bean.getPol_sta()%>'>
                    </td>
                    <td class=title>의견진술기한</td>
                    <td>&nbsp;<input type="text" name="obj_end_dt" value="<%=AddUtil.ChangeDate2(f_bean.getObj_end_dt())%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    까지 </td>
                </tr>
                <%if(!FineDocListBn.getDoc_id().equals("")){%>
                <tr>
                    <td class=title>공문</td>
                    <td colspan="3">&nbsp;<font color=a4005b>[문서번호] </font><%=FineDocBn.getDoc_id()%> &nbsp;<font color=a4005b>[시행일자]</font> <%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%> &nbsp;<font color=a4005b>[인쇄일자] </font><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%></td>
                </tr>
                <%}%>
                <%if(!f_bean.getObj_dt1().equals("")){%>
                <tr>
                    <td class=title>이의신청</td>
                    <td colspan="3">&nbsp;1차:
                        <input type="text" name="obj_dt1" value="<%=f_bean.getObj_dt1()%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    2차:
                    <input type="text" name="obj_dt2" value="<%=f_bean.getObj_dt2()%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    3차:
                    <input type="text" name="obj_dt3" value="<%=f_bean.getObj_dt3()%>" size="12" maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>과태료 납부</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title width="15%">과실구분</td>
                    <td width="32%">&nbsp;<select name="fault_st" disabled>
                        <option value="1" <%if(f_bean.getFault_st().equals("1"))%>selected<%%>>고객과실</option>
                        <option value="2" <%if(f_bean.getFault_st().equals("2"))%>selected<%%>>업무상과실</option>
                      </select>
                    </td>
                    <td class=title width="16%">납부구분</td>
                    <td width="37%">&nbsp;<select name="paid_st" disabled>
                        <option value="1" <%if(f_bean.getPaid_st().equals("1"))%>selected<%%>>납부자변경</option>
                        <option value="2" <%if(f_bean.getPaid_st().equals("2"))%>selected<%%>>고객납입</option>
                        <option value="4" <%if(f_bean.getPaid_st().equals("4"))%>selected<%%>>수금납입</option>
                        <option value="3" <%if(f_bean.getPaid_st().equals("3"))%>selected<%%>>회사대납</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>업무과실자</td>
                    <td>&nbsp;<select name='fault_nm' disabled>
                        <option value="">없음</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(f_bean.getFault_nm().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title>업무과실자부담금액</td>
                    <td>&nbsp;<input type="text" name="fault_amt" value="<%=Util.parseDecimal(f_bean.getFault_amt())%>" size="10" maxlength=10 class=whitenum onBlur="javascript:this.value=parseDecimal(this.value)">
                    원</td>
                </tr>
                <tr>
                    <td class=title>고지서 접수일자</td>
                    <td>&nbsp;<input type="text" name="rec_dt" value="<%=AddUtil.ChangeDate2(f_bean.getRec_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>납부기한</td>
                    <td>&nbsp;<input type="text" name="paid_end_dt" value="<%=AddUtil.ChangeDate2(f_bean.getPaid_end_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    까지</td>
                </tr>
                <tr>
                    <td class=title>납부금액</td>
                    <td>&nbsp;<input type="text" name="paid_amt" value="<%=Util.parseDecimal(f_bean.getPaid_amt())%>" size="10" maxlength=6 class=whitenum onBlur="javascript:this.value=parseDecimal(this.value)">
                    원</td>
                    <td class=title>납부일자</td>
                    <td>&nbsp;<input type="text" name="proxy_dt" value="<%=AddUtil.ChangeDate2(f_bean.getProxy_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class=title>특이사항</td>
                    <td colspan="3">&nbsp;<%=f_bean.getNote()%><!--<textarea name="note" cols=100 rows=2 class=default></textarea>-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대납과태료 수금</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td class=title colspan="2">청구일자</td>
                    <td width="32%">&nbsp;<input type="text" name="dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getDem_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width="16%">최초청구일</td>
                    <td width="11%">&nbsp;<input type="text" name="f_dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getF_dem_dt())%>" size="12" class=whitetext readonly>
                    </td>
                    <td class=title width="15%">최종청구일</td>
                    <td width="11%">&nbsp;<input type="text" name="e_dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getE_dem_dt())%>" size="12" class=whitetext readonly>
                    </td>
                </tr>
                <tr>
                    <td class=title colspan="2">입금예정일</td>
                    <td>&nbsp;<input type="text" name="rec_plan_dt" value="<%=AddUtil.ChangeDate2(f_bean.getRec_plan_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>수금일자</td>
                    <td colspan="3">&nbsp;<input type="text" name="coll_dt" value="<%=AddUtil.ChangeDate2(f_bean.getColl_dt())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class=title rowspan="2" width="6%">세금<br>
                    계산서</td>
                    <td class=title width="9%">발행여부</td>
                    <td>&nbsp;<select name="tax_yn" disabled>
                        <option value="0" <%if(f_bean.getTax_yn().equals("0"))%>selected<%%>>미발행</option>
                        <option value="1" <%if(f_bean.getTax_yn().equals("1"))%>selected<%%>>발행</option>
                      </select>
                    </td>
                    <td class=title>부가세 포함여부</td>
                    <td colspan="3">&nbsp;<select name="vat_yn" disabled>
                        <option value="0" <%if(f_bean.getVat_yn().equals("0"))%>selected<%%>>미포함</option>
                        <option value="1" <%if(f_bean.getVat_yn().equals("1"))%>selected<%%>>포함</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>거래구분</td>
                    <td>&nbsp;<select name="busi_st" disabled>
                        <option value="1" <%if(f_bean.getBusi_st().equals("1"))%>selected<%%>>과태료</option>
                        <option value="2" <%if(f_bean.getBusi_st().equals("2"))%>selected<%%>>차량수리</option>
                      </select>
                    </td>
                    <td class=title>거래명세서포함여부</td>
                    <td colspan="3">&nbsp;<select name="bill_doc_yn" disabled>
                        <option value="0" <%if(f_bean.getBill_doc_yn().equals("0"))%>selected<%%>>미포함</option>
                        <option value="1" <%if(f_bean.getBill_doc_yn().equals("1"))%>selected<%%>>포함</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title colspan="2">면제여부</td>
                    <td colspan="5">&nbsp;<input type='checkbox' name='no_paid_yn' value="Y" <%if(f_bean.getNo_paid_yn().equals("Y"))%>checked<%%>>
                    사유:
                      <input type="text" name="no_paid_cau" value="<%=f_bean.getNo_paid_cau()%>" size="60" class=whitetext >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>     <td class=h></td>    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="15%">통지서/고지서</td>
                    <td>
						  <%if(!file_name1.equals("")){%>	
						  &nbsp;					  	
						  <%	if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
							 	<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
							<%	}else{%>
							 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
							<%	}%>								  
						  <%}%>							
						  <%if(!file_name3.equals("")){%>	
						  &nbsp;					  
						  <%	if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
							 	<a href="javascript:openPopP('<%=file_type3%>','<%=seq3%>');" title='보기' ><%=file_name3%></a>
							<%	}else{%>
							 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=file_name3%></a>
							<%	}%>								  
						  <%}%>
					</td>                    
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td colspan="2">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td align=right><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a>            </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>

