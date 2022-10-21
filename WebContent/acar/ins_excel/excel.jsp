<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

	//등록하기
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 					return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');					return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
		
		if(fm.gubun1[5].checked == true){
			if(fm.pay_dt.value == ''){ alert('일괄납부처리 납부일자를 입력하십시오.'); fm.pay_dt.focus(); return; }
			if(fm.est_dt.value == ''){ alert('일괄납부처리 예정일자를 입력하십시오.'); fm.est_dt.focus(); return; }
		}
			
		if(fm.gubun1[0].checked == true){				fm.action = 'excel_renew.jsp';			}
		else if(fm.gubun1[1].checked == true){			fm.action = 'excel_renew_conid.jsp';	}						
		else if(fm.gubun1[2].checked == true){			fm.action = 'excel_renew2.jsp';			}						
		else if(fm.gubun1[3].checked == true){			fm.action = 'excel_renew_conid2.jsp';	}						
		else if(fm.gubun1[4].checked == true){			fm.action = 'excel_pay_20090310.jsp';	}								
		else if(fm.gubun1[5].checked == true){			fm.action = 'excel_pay_20210410_a.jsp';	}
		else if(fm.gubun1[6].checked == true){			fm.action = 'excel_chk.jsp';			}
		else if(fm.gubun1[7].checked == true){			fm.action = 'excel_modify.jsp';			}
		else if(fm.gubun1[8].checked == true){			fm.action = 'excel_blackbox_sms.jsp';	}
		else if(fm.gubun1[9].checked == true){			fm.action = 'excel_blackbox_view.jsp';	}
		else if(fm.gubun1[10].checked == true){			fm.action = 'excel_change.jsp';			}
		else if(fm.gubun1[11].checked == true){			fm.action = 'excel_cls.jsp';			}
		else if(fm.gubun1[12].checked == true){			fm.action = 'excel_change_new.jsp';		}
		else if(fm.gubun1[13].checked == true){			fm.action = 'excel_new.jsp';			}
		else if(fm.gubun1[14].checked == true){			fm.action = 'excel_sync.jsp';			}
		else if(fm.gubun1[15].checked == true){			fm.action = 'excel_sync_save.jsp';		}
		else if(fm.gubun1[16].checked == true){			fm.action = 'excel_hightech_update.jsp';}
		else if(fm.gubun1[17].checked == true){			fm.action = 'excel_firmEmpNm_update.jsp';}
		else if(fm.gubun1[18].checked == true){			fm.action = 'excel_hightech_insUpdate.jsp';}
		else if(fm.gubun1[19].checked == true){			fm.action = 'excel_exp_list.jsp';		}
		else if(fm.gubun1[20].checked == true){			fm.action = 'excel_blackbox_cost.jsp';	}
		else if(fm.gubun1[21].checked == true){			fm.action = 'excel_rate.jsp';			}
		else{			alert('구분을 선택하십시오.');		return;									}
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		//fm.target = "_blank";
		fm.submit();

	}
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td> <font color="red">[ 엑셀파일을 이용한 보험 처리  ]</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="100" class='title'>파일</td>
                    <td>&nbsp;<input type="file" name="filename" size="80"></td>
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td align="right">
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;	        
	    </td>
    </tr>    
    <tr>
        <td align="right" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>               
                <tr>
                    <td>	
                        <!-- 0 -->	   
                        <input type="radio" name="gubun1" value="1">
                        <b>업무용 갱신등록1 </b> <font color=red><- 매년 2월10일 일괄등록 처리시 (갱신보험, 보험스케줄 생성)</font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①증권번호</td>
                                <td style="font-size : 8pt;" class="title">②차량번호</td>
                                <td style="font-size : 8pt;" class="title">③대인배상Ⅰ</td>
                                <td style="font-size : 8pt;" class="title">④대인배상Ⅱ</td>
                                <td style="font-size : 8pt;" class="title">⑤대물배상</td>
                                <td style="font-size : 8pt;" class="title">⑥자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">⑦무보험차상해</td>
                                <td style="font-size : 8pt;" class="title">⑧분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">⑨자기차량손해</td>
                                <td style="font-size : 8pt;" class="title">⑩애니카</td>
                                <td style="font-size : 8pt;" class="title">⑪총보험료</td>
                                <td style="font-size : 8pt;" class="title">⑫임직원전용보험</td>                                
                            </tr>
                        </table>                        
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>      	
                <tr>
                    <td>			   
                        <!-- 1 -->	   
                        <input type="radio" name="gubun1" value="7">
                        <b>업무용 갱신등록2 (설계번호, 갱신증권번호) - 증권번호 수정하기</b> <font color=red><- 일괄등록후 실 증권번호로 변경 처리시 </font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①설계번호</td>					
                                <td style="font-size : 8pt;" class="title">②증권번호</td>
                                <td style="font-size : 8pt;" class="title">③차량번호</td>
                            </tr>
                        </table>
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  
                <tr>
                    <td>			   
                        <!-- 2 -->	
                        <input type="radio" name="gubun1" value="2">
                        <b>영업용 갱신등록 </b> <font color=red><- 일괄갱신등록 처리시 (회계전표, 메일발송 처리 포함)</font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①증권번호</td>
                                <td style="font-size : 8pt;" class="title">②차량번호</td>
                                <td style="font-size : 8pt;" class="title">③대인배상Ⅰ</td>
                                <td style="font-size : 8pt;" class="title">④대인배상Ⅱ</td>
                                <td style="font-size : 8pt;" class="title">⑤대물배상</td>
                                <td style="font-size : 8pt;" class="title">⑥자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">⑦무보험차상해</td>
                                <td style="font-size : 8pt;" class="title">⑧분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">⑨자기차량손해</td>
                                <td style="font-size : 8pt;" class="title">⑩애니카</td>
                                <td style="font-size : 8pt;" class="title">⑪총보험료</td>
                                <td style="font-size : 8pt;" class="title">⑫임직원전용보험</td>                                
                            </tr>
                        </table>
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>			   
                        <!-- 3 -->	
                        <input type="radio" name="gubun1" value="7">
                        <b>영업용 갱신등록2 (설계번호, 갱신증권번호) - 증권번호 수정하기</b> <font color=red><- 일괄등록후 실 증권번호로 변경 처리시 </font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①설계번호</td>					
                                <td style="font-size : 8pt;" class="title">②증권번호</td>
                                <td style="font-size : 8pt;" class="title">③차량번호</td>
                            </tr>
                        </table>                        
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <!-- 4 -->	
                        <input type="radio" name="gubun1" value="9">
			            일괄 납부처리(구) (엑셀폼 확인후 처리, 10000개 제한있음, 금액/증권번호만 처리)		
			            <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①미결구분</td>					
                                <td style="font-size : 8pt;" class="title">②연번</td>
                                <td style="font-size : 8pt;" class="title">③관련번호</td>
                                <td style="font-size : 10pt;" class="title"><b>④금액</b></td>
                                <td style="font-size : 8pt;" class="title">⑤마감일자</td>
                                <td style="font-size : 8pt;" class="title">⑥적용개시일자</td>
                                <td style="font-size : 10pt;" class="title"><b>⑦증권번호</b></td>
                                <td style="font-size : 8pt;" class="title">⑧입력일자</td>
                                <td style="font-size : 8pt;" class="title">⑨비고</td>
                            </tr>
                        </table>   
  		            </td>
                </tr>			                              
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <!-- 5 -->	
                        <input type="radio" name="gubun1" value="21">
			            <b>일괄 납부처리(신)</b> (파일 읽어 바로 처리)	
			            <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 10pt;" class="title"><b>①금액</b></td>
                                <td style="font-size : 10pt;" class="title"><b>②증권번호</b></td>
                            </tr>
                        </table>   	
                        납부일자 : <input name="pay_dt" type="text" class=text value="" size="10">
                        예정일자 : <input name="est_dt" type="text" class=text value="" size="10">
  		            </td>
                </tr>			                              
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="10">			
			<b>보험사엑셀 점검</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1 NO</td>					
                                <td style="font-size : 8pt;" class="title">2 증권번호</td>
                                <td style="font-size : 8pt;" class="title">3 고객명</td>
                                <td style="font-size : 8pt;" class="title">4 차량번호</td>
                                <td style="font-size : 8pt;" class="title">5 금액</td>
                                <td style="font-size : 8pt;" class="title">6 수납일</td>
                            </tr>
                        </table>                        
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="12">			
			<b>영업용 가입보험 재등록(금액변경 일괄처리)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①증권번호</td>
                                <td style="font-size : 8pt;" class="title">②차량번호</td>
                                <td style="font-size : 8pt;" class="title">③대인배상Ⅰ</td>
                                <td style="font-size : 8pt;" class="title">④대인배상Ⅱ</td>
                                <td style="font-size : 8pt;" class="title">⑤대물배상</td>
                                <td style="font-size : 8pt;" class="title">⑥자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">⑦무보험차상해</td>
                                <td style="font-size : 8pt;" class="title">⑧분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">⑨총보험료</td>
                                <td style="font-size : 8pt;" class="title">⑩수납일자</td>
                            </tr>
                        </table>                        
  		    </td>
                </tr>	             
                <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="13">			
			<b>블랙박스 미장착 차량 담당자 문자발송</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①연번</td>
                                <td style="font-size : 8pt;" class="title">②공제시기</td>
                                <td style="font-size : 8pt;" class="title">③차량번호</td>
                                <td style="font-size : 8pt;" class="title">④차명</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	       
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="16">			
			<b>블랙박스 미장착 차량 조회</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">①연번</td>
                                <td style="font-size : 8pt;" class="title">②공제시기</td>
                                <td style="font-size : 8pt;" class="title">③차량번호</td>
                                <td style="font-size : 8pt;" class="title">④차명</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	 
                  <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="16">			
			<b>보험 가입 변경</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1.차량번호</td>
                                <td style="font-size : 8pt;" class="title">2.차명</td>
                                <td style="font-size : 8pt;" class="title">3.상호명</td>
                                <td style="font-size : 8pt;" class="title">4.사업자번호</td>
                                <td style="font-size : 8pt;" class="title">5.대여개시일</td>
                                <td style="font-size : 8pt;" class="title">6.대여만료일</td>
                                <td style="font-size : 8pt;" class="title">7.변경전보험</td>
                                <td style="font-size : 8pt;" class="title">8.보험회사</td>
                                <td style="font-size : 8pt;" class="title">9.보험시작일</td>
                                <td style="font-size : 8pt;" class="title">10.보험만료일</td>
                            <tr>
                                <td style="font-size : 8pt;" class="title">11.변경후보험</td>
                                <td style="font-size : 8pt;" class="title">12.영업자</td>
                                <td style="font-size : 8pt;" class="title">13.미가입승인</td>
                                <td style="font-size : 8pt;" class="title">14.변경항목</td>
                                <td style="font-size : 8pt;" class="title">15.변경전</td>
                                <td style="font-size : 8pt;" class="title">16.변경후</td>
                                <td style="font-size : 8pt;" class="title">17.배서기준일</td>
                                <td style="font-size : 8pt;" class="title">18.추징보험료</td>
                                <td style="font-size : 8pt;" class="title">19.증권번호</td>
                                <td style="font-size : 8pt;" class="title">20.대인배상Ⅰ</td>
                            </tr>
                          	<tr>
                                <td style="font-size : 8pt;" class="title">21.대인배상Ⅱ</td>
                                <td style="font-size : 8pt;" class="title">22.대물배상</td>
                                <td style="font-size : 8pt;" class="title">23.자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">24.무보험차상해</td>
                                <td style="font-size : 8pt;" class="title">25.분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">26.자기차량손해</td>
                                <td style="font-size : 8pt;" class="title">27.애니카</td>
                                <td style="font-size : 8pt;" class="title">28.총보험료</td>
                            </tr>    
                        </table>
  		    </td>
                </tr>	                 
                <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="11">
			<b>일괄 보험해지등록</b>
			 <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                 <td style="font-size : 8pt;" class="title">①차량번호</td>
                                <td style="font-size : 8pt;" class="title">②증권번호</td>
                                <td style="font-size : 8pt;" class="title">③차종</td>
                                <td style="font-size : 8pt;" class="title">④해지사유발생일자</td>
                                <td style="font-size : 8pt;" class="title">⑤용도변경내용</td>
                                <td style="font-size : 8pt;" class="title">⑥용도변경목적</td>
                                <td style="font-size : 8pt;" class="title">⑦청구/승계일자</td>
                                <td style="font-size : 8pt;" class="title">⑧환급금</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                 <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="11">
			<b>보험 가입 변경</b>
			 <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                 <td style="font-size : 8pt;" class="title">1.증권번호</td>
                                <td style="font-size : 8pt;" class="title">2.배서번호</td>
                                <td style="font-size : 8pt;" class="title">3.피공제자명</td>
                                <td style="font-size : 8pt;" class="title">4.계약자명</td>
                                <td style="font-size : 8pt;" class="title">5.소유주명</td>
                                <td style="font-size : 8pt;" class="title">6.가입시차량번호</td>
                                <td style="font-size : 8pt;" class="title">7.차량번호</td>
                                <td style="font-size : 8pt;" class="title">8.차명</td>
                                <td style="font-size : 8pt;" class="title">9.연령</td>
                                <td style="font-size : 8pt;" class="title">10.공제기간</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">11.납입방법</td>
                                <td style="font-size : 8pt;" class="title">12.분납회차</td>
                                <td style="font-size : 8pt;" class="title">13.배서코드</td>
                                <td style="font-size : 8pt;" class="title">14.배서항목명</td>
                                <td style="font-size : 8pt;" class="title">15.변경전</td>
                                <td style="font-size : 8pt;" class="title">16.변경후</td>
                                <td style="font-size : 8pt;" class="title">17.가입담보</td>
                                <td style="font-size : 8pt;" class="title">18.대인원</td>
                                <td style="font-size : 8pt;" class="title">19.대인투</td>
                                <td style="font-size : 8pt;" class="title">20.대물배상</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">21.자손</td>
                                <td style="font-size : 8pt;" class="title">22.무보험</td>
                                <td style="font-size : 8pt;" class="title">23.자차</td>
                                <td style="font-size : 8pt;" class="title">24.대여자동차복구</td>
                                <td style="font-size : 8pt;" class="title">25.자상</td>
                                <td style="font-size : 8pt;" class="title">26.긴출</td>
                                <td style="font-size : 8pt;" class="title">27.휴업손해</td>
                                <td style="font-size : 8pt;" class="title">28.분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">29.차대차한정</td>
                                <td style="font-size : 8pt;" class="title">30.장기여부</td>
                            </tr>
                            <tr>
                            		
                                <td style="font-size : 8pt;" class="title">31.차종</td>
                                <td style="font-size : 8pt;" class="title">32.차량등록일</td>
                                <td style="font-size : 8pt;" class="title">33.결제예정금액</td>
                                <td style="font-size : 8pt;" class="title">34.수납일자</td>
                                <td style="font-size : 8pt;" class="title">35.납입구분</td>
                                <td style="font-size : 8pt;" class="title">36.신규갱신</td>
                                <td style="font-size : 8pt;" class="title">37.공제종목</td>
                                <td style="font-size : 8pt;" class="title">38.배서기준일</td>
                                <td style="font-size : 8pt;" class="title">39.담보별보험료</td>
                                <td style="font-size : 8pt;" class="title">40.대인원</td>
                            </tr>
                            <tr>
                                <td style="font-size : 8pt;" class="title">41.대인투</td>
                                <td style="font-size : 8pt;" class="title">42.대물배상</td>
                                <td style="font-size : 8pt;" class="title">43.자손</td>
                                <td style="font-size : 8pt;" class="title">44.무보험</td>
                                <td style="font-size : 8pt;" class="title">45.자차</td>
                                <td style="font-size : 8pt;" class="title">46.대여자동차복구</td>
                                <td style="font-size : 8pt;" class="title">47.자상</td>
                                <td style="font-size : 8pt;" class="title">48.긴출</td>
                                <td style="font-size : 8pt;" class="title">49.휴업손해</td>
                                <td style="font-size : 8pt;" class="title">50.분담금할증한정</td>
                             </tr>
                             <tr>
                                <td style="font-size : 8pt;" class="title">51.차대차한정</td>
                                <td style="font-size : 8pt;" class="title">52.운전자명</td>
                                <td style="font-size : 8pt;" class="title">53.운전자순번</td>
                                <td style="font-size : 8pt;" class="title">54.면허번호</td>
                                <td style="font-size : 8pt;" class="title">55.운전자한정시기</td>
                                <td style="font-size : 8pt;" class="title">56.운전자한정종기</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                 <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="12">
			<b>렌터카공제조합 보험 가입 (신규) </b>
			 <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                 <td style="font-size : 8pt;" class="title">1.증권번호</td>
                                <td style="font-size : 8pt;" class="title">2.배서번호</td>
                                <td style="font-size : 8pt;" class="title">3.피공제자명</td>
                                <td style="font-size : 8pt;" class="title">4.계약자명</td>
                                <td style="font-size : 8pt;" class="title">5.소유주명</td>
                                <td style="font-size : 8pt;" class="title">6.가입시차량번호</td>
                                <td style="font-size : 8pt;" class="title">7.차량번호</td>
                                <td style="font-size : 8pt;" class="title">8.차명</td>
                                <td style="font-size : 8pt;" class="title">9.연령</td>
                                <td style="font-size : 8pt;" class="title">10.공제기간</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">11.납입방법</td>
                                <td style="font-size : 8pt;" class="title">12.분납회차</td>
                                <td style="font-size : 8pt;" class="title">13.배서코드</td>
                                <td style="font-size : 8pt;" class="title">14.배서항목명</td>
                                <td style="font-size : 8pt;" class="title">15.변경전</td>
                                <td style="font-size : 8pt;" class="title">16.변경후</td>
                                <td style="font-size : 8pt;" class="title">17.가입담보</td>
                                <td style="font-size : 8pt;" class="title">18.대인원</td>
                                <td style="font-size : 8pt;" class="title">19.대인투</td>
                                <td style="font-size : 8pt;" class="title">20.대물배상</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">21.자손</td>
                                <td style="font-size : 8pt;" class="title">22.무보험</td>
                                <td style="font-size : 8pt;" class="title">23.자차</td>
                                <td style="font-size : 8pt;" class="title">24.대여자동차복구</td>
                                <td style="font-size : 8pt;" class="title">25.자상</td>
                                <td style="font-size : 8pt;" class="title">26.긴출</td>
                                <td style="font-size : 8pt;" class="title">27.휴업손해</td>
                                <td style="font-size : 8pt;" class="title">28.분담금할증한정</td>
                                <td style="font-size : 8pt;" class="title">29.차대차한정</td>
                                <td style="font-size : 8pt;" class="title">30.장기여부</td>
                            </tr>
                            <tr>
                            		
                                <td style="font-size : 8pt;" class="title">31.차종</td>
                                <td style="font-size : 8pt;" class="title">32.차량등록일</td>
                                <td style="font-size : 8pt;" class="title">33.결제예정금액</td>
                                <td style="font-size : 8pt;" class="title">34.수납일자</td>
                                <td style="font-size : 8pt;" class="title">35.납입구분</td>
                                <td style="font-size : 8pt;" class="title">36.신규갱신</td>
                                <td style="font-size : 8pt;" class="title">37.공제종목</td>
                                <td style="font-size : 8pt;" class="title">38.배서기준일</td>
                                <td style="font-size : 8pt;" class="title">39.담보별보험료</td>
                                <td style="font-size : 8pt;" class="title">40.대인원</td>
                            </tr>
                            <tr>
                                <td style="font-size : 8pt;" class="title">41.대인투</td>
                                <td style="font-size : 8pt;" class="title">42.대물배상</td>
                                <td style="font-size : 8pt;" class="title">43.자손</td>
                                <td style="font-size : 8pt;" class="title">44.무보험</td>
                                <td style="font-size : 8pt;" class="title">45.자차</td>
                                <td style="font-size : 8pt;" class="title">46.대여자동차복구</td>
                                <td style="font-size : 8pt;" class="title">47.자상</td>
                                <td style="font-size : 8pt;" class="title">48.긴출</td>
                                <td style="font-size : 8pt;" class="title">49.휴업손해</td>
                                <td style="font-size : 8pt;" class="title">50.분담금할증한정</td>
                             </tr>
                             <tr>
                                <td style="font-size : 8pt;" class="title">51.차대차한정</td>
                                <td style="font-size : 8pt;" class="title">52.운전자명</td>
                                <td style="font-size : 8pt;" class="title">53.운전자순번</td>
                                <td style="font-size : 8pt;" class="title">54.면허번호</td>
                                <td style="font-size : 8pt;" class="title">55.운전자한정시기</td>
                                <td style="font-size : 8pt;" class="title">56.운전자한정종기</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="13">			
						<b>현재 보험사와 정보 비교하기</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1 증권번호</td>
                                <td style="font-size : 8pt;" class="title">2 차량번호</td>
                                <td style="font-size : 8pt;" class="title">3 상호</td>
                                <td style="font-size : 8pt;" class="title">4 사업자번호</td>
                                <td style="font-size : 8pt;" class="title">5 연령</td>
                                <td style="font-size : 8pt;" class="title">6 대물연령</td>
                                <td style="font-size : 8pt;" class="title">7 임직원</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="14">			
						<b>보험 동기화 작업</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- 증권번호	차량번호	차대번호	고객명	사업자번호	보험시작일	보험만기일	연령특약	임직원한정  -->
                                <td style="font-size : 8pt;" class="title">1 증권번호</td>
                                <td style="font-size : 8pt;" class="title">2 차량번호</td>
                                <td style="font-size : 8pt;" class="title">3 차대번호</td>
                                <td style="font-size : 8pt;" class="title">4 고객명</td>
                                <td style="font-size : 8pt;" class="title">5 사업자번호</td>
                                <td style="font-size : 8pt;" class="title">6 보험시작일</td>
                                <td style="font-size : 8pt;" class="title">7 보험만기일</td>
                                <td style="font-size : 8pt;" class="title">8 연령특약</td>
                                <td style="font-size : 8pt;" class="title">9 임직원한정</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  	
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="15">			
						<b>첨단산업관련 데이터 업데이트(cont_etc)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- 증권번호	차량번호	차대번호	고객명	사업자번호	보험시작일	보험만기일	연령특약	임직원한정  -->
                                <td style="font-size : 8pt;" class="title">1 차량번호</td>
                                <td style="font-size : 8pt;" class="title">2 최초등록일</td>
                                <td style="font-size : 8pt;" class="title">3 차선이탈(제어형)LKAS</td>
                                <td style="font-size : 8pt;" class="title">4 차선이탈(경고형)LDWS</td>
                                <td style="font-size : 8pt;" class="title">5 긴급제동(제어형)AEB</td>
                                <td style="font-size : 8pt;" class="title">6 긴급제동(경고형)FCW</td>
                                <td style="font-size : 8pt;" class="title">7 전기자동차EV</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="16">			
						<b>임차인 정보 업데이트(insur firm_emp_nm)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1 증권번호</td>
                                <td style="font-size : 8pt;" class="title">2 상호</td>
                                <td style="font-size : 8pt;" class="title">3 사업자번호</td>
                                <td style="font-size : 8pt;" class="title">4 연령</td>
                                <td style="font-size : 8pt;" class="title">5 대물</td>
                                <td style="font-size : 8pt;" class="title">6 임직원</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="17">			
						<b>첨단산업관련 데이터 업데이트(insur)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- 증권번호	차량번호	차대번호	고객명	사업자번호	보험시작일	보험만기일	연령특약	임직원한정  -->
                                <td style="font-size : 8pt;" class="title">1 증권번호</td>
                                <td style="font-size : 8pt;" class="title">2 보험시작일</td>
                                <td style="font-size : 8pt;" class="title">3 차선이탈(제어형)LKAS</td>
                                <td style="font-size : 8pt;" class="title">4 차선이탈(경고형)LDWS</td>
                                <td style="font-size : 8pt;" class="title">5 긴급제동(제어형)AEB</td>
                                <td style="font-size : 8pt;" class="title">6 긴급제동(경고형)FCW</td>
                                <td style="font-size : 8pt;" class="title">7 전기자동차EV</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="18">			
						<b>만기리스트</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- No 차량번호	피공제자명	공제기간	연령특약	분납방법	차명	가입담보	계약상태	임직원특약	증권번호  -->
                                <td style="font-size : 8pt;" class="title">1 No</td>
                                <td style="font-size : 8pt;" class="title">2 차량번호</td>
                                <td style="font-size : 8pt;" class="title">3 피공제자명</td>
                                <td style="font-size : 8pt;" class="title">4 공제기간</td>
                                <td style="font-size : 8pt;" class="title">5 연령특약</td>
                                <td style="font-size : 8pt;" class="title">6 분납방법</td>
                                <td style="font-size : 8pt;" class="title">7 차명</td>
                                <td style="font-size : 8pt;" class="title">8 가입담보</td>
                                <td style="font-size : 8pt;" class="title">9 계약상태</td>
                                <td style="font-size : 8pt;" class="title">10 임직원특약</td>
                                <td style="font-size : 8pt;" class="title">11 증권번호</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="19">			
						<b>삼성화재 블랙박스 보험료 변경건(excel_blackbox_cost)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- No 차량번호	피공제자명	공제기간	연령특약	분납방법	차명	가입담보	계약상태	임직원특약	증권번호  -->
                                <td style="font-size : 8pt;" class="title">1 연번</td>
                                <td style="font-size : 8pt;" class="title">2 차량구분</td>
                                <td style="font-size : 8pt;" class="title">3 고객명</td>
                                <td style="font-size : 8pt;" class="title">4 사업자번호</td>
                                <td style="font-size : 8pt;" class="title">5 차량번호</td>
                                <td style="font-size : 8pt;" class="title">6 증권번호</td>
                                <td style="font-size : 8pt;" class="title">7 대인배상1</td>
                                <td style="font-size : 8pt;" class="title">8 대인배상2</td>
                                <td style="font-size : 8pt;" class="title">9 대물배상</td>
                                <td style="font-size : 8pt;" class="title">10 자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">11 무보험자동차에의한상해</td>
                                <td style="font-size : 8pt;" class="title">12 차량단독사고보상</td>
                                <td style="font-size : 8pt;" class="title">13 다른자동차차량손해지원특별약관</td>
                                <td style="font-size : 8pt;" class="title">14 설계번호</td>
                                <td style="font-size : 8pt;" class="title">15 블랙박스 할인보험료</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  	
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="20">			
						<b>요율정정배서(excel_rate)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- No 차량번호	피공제자명	공제기간	연령특약	분납방법	차명	가입담보	계약상태	임직원특약	증권번호  -->
                                <td style="font-size : 8pt;" class="title">1 연번</td>
                                <td style="font-size : 8pt;" class="title">2 차량구분</td>
                                <td style="font-size : 8pt;" class="title">3 고객명</td>
                                <td style="font-size : 8pt;" class="title">4 사업자번호</td>
                                <td style="font-size : 8pt;" class="title">5 차량번호</td>
                                <td style="font-size : 8pt;" class="title">6 증권번호</td>
                                <td style="font-size : 8pt;" class="title">7 대인배상1</td>
                                <td style="font-size : 8pt;" class="title">8 대인배상2</td>
                                <td style="font-size : 8pt;" class="title">9 대물배상</td>
                                <td style="font-size : 8pt;" class="title">10 자기신체사고</td>
                                <td style="font-size : 8pt;" class="title">11 무보험자동차에의한상해</td>
                                <td style="font-size : 8pt;" class="title">12 차량단독사고보상</td>
                                <td style="font-size : 8pt;" class="title">13 다른자동차차량손해지원특별약관</td>
                                <td style="font-size : 8pt;" class="title">14 설계번호</td>
                                <td style="font-size : 8pt;" class="title">15 요율정정 후 보험료</td>
                            </tr>
                        </table>		                                                
  		    </td>
                </tr>	
                    			                		                             
            </table>
	</td>
    </tr>	      
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
	</td>
    </tr>
</table>
</form>
</center>
</body>
</html>
