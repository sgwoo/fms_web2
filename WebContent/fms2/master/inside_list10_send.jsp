<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,java.text.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int succ_cnt = 0;
	int fail_cnt = 0;
	int skip_cnt = 0;

	if(c_id !=null ){
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String c_ids[] = c_id.split(",");
		int file_seq = ad_db.getAucFileSeq();
		int actn_num = ad_db.getAucRelSeq();
		
		String fm_start_dt ="";
		String fm_end_dt ="";
		
		if(!start_dt.equals("")){
			fm_start_dt = AddUtil.ChangeDate2(start_dt);
		}else{
			fm_start_dt = AddUtil.getDate().substring(0,8)+"01";
		}
		
		if(!end_dt.equals("")){
			fm_end_dt = AddUtil.ChangeDate2(end_dt);
		}else{
			fm_end_dt = AddUtil.getDate();
		}
		
		String file_name = "FMS 재리스계약차량리스트 "+fm_start_dt+" ~ "+fm_end_dt;
		
	
		
		for(String car_mng_id : c_ids){
			Hashtable ht = ad_db.getInsideReq10_3(car_mng_id);
			AucBean auc = new AucBean();
			
			if(ht.get("ACTN_DT") !=null){
				auc.setActn_dt(format.parse(String.valueOf(ht.get("ACTN_DT"))) );
			}
			auc.setActn_off_nm 	(String.valueOf(ht.get("ACTN_OFF_NM"))                  );
			auc.setActn_cnt     (Integer.parseInt(String.valueOf(ht.get("ACTN_CNT")))   );
			auc.setActn_num     (actn_num												);
			auc.setCar_name     (String.valueOf(ht.get("CAR_NAME"))                     );
			auc.setCar_y_form   (String.valueOf(ht.get("CAR_Y_FORM"))                   );
			auc.setAuto_yn      (String.valueOf(ht.get("AUTO_YN"))                      );
			auc.setFuel_kd      (String.valueOf(ht.get("FUEL_KD"))                      );
			auc.setDpm          (Integer.parseInt(String.valueOf(ht.get("DPM")))        );
			auc.setAgree_dist   (Integer.parseInt(String.valueOf(ht.get("AGREE_DIST"))) );
			auc.setCol          (String.valueOf(ht.get("COL"))                          );
			auc.setCar_use      (String.valueOf(ht.get("CAR_USE"))                      );
			auc.setCar_own      (String.valueOf(ht.get("CAR_OWN"))                      );
			auc.setRating1      (String.valueOf(ht.get("RATING1"))                      );
			auc.setRating2      (String.valueOf(ht.get("RATING2"))                      );
			auc.setSt_pr        (0      );
			auc.setNak_pr       (Integer.parseInt(String.valueOf(ht.get("NAK_PR")))     );
			auc.setCar_name2    (String.valueOf(ht.get("CAR_NAME2"))                    );
			auc.setJg_code      (String.valueOf(String.valueOf(ht.get("JG_CODE")))      );
			if(ht.get("INIT_REG_DT") !=null){
				auc.setInit_reg_dt  (format.parse(String.valueOf(ht.get("INIT_REG_DT")))    );
			}
			auc.setOpt          (String.valueOf(ht.get("OPT"))                          );
			auc.setEtc          (String.valueOf(ht.get("ETC"))                          );
			auc.setActn_car_amt (Integer.parseInt(String.valueOf(ht.get("ACTN_CAR_AMT"))));
			auc.setTaking_p     (Integer.parseInt(String.valueOf(ht.get("TAKING_P")))   );
			auc.setCar_no       (String.valueOf(ht.get("CAR_NO"))                       );
			auc.setHp_pr        (0      );
			auc.setFile_seq      (file_seq);
			auc.setD_gubun		("fms_rel");
				
			int count = ad_db.getAucCnt(auc);
			actn_num +=1;
			
			if(count==0){
				int flag = ad_db.insertActnRaw(auc);
				//System.out.println(auc);
				if(flag > 0){
					succ_cnt +=1;
				}else{
					fail_cnt +=1;
				}
			}else{
				skip_cnt +=1;
			}
			
			//System.out.println(auc);
		}
		
		//System.out.println(file_name);
			
		ad_db.insertHist(file_seq, file_name,"5", succ_cnt, fail_cnt, skip_cnt );
	}
%>
	
<html>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<script>
	var succ_cnt = '<%=succ_cnt%>';
	var fail_cnt = '<%=fail_cnt%>';
	var skip_cnt = '<%=skip_cnt%>';
	
	alert("등록 성공차량 : " + succ_cnt +"\n"+"등록 실패차량 : " + fail_cnt+"\n"+"등록 중복차량 : " + skip_cnt);
	self.close();
	
</script>


<body>

</body>
