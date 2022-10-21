	//입력시 자동 계산하기	
	function set_cls_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;

		var mon = toInt(fm.h_mon.value);
		var r_mon = toInt(fm.h_r_mon.value);
		var r_day = toInt(fm.h_r_day.value);
		var pp = toInt(parseDigit(fm.pp_amt.value));
		var fee = toInt(parseDigit(fm.fee_amt.value));
		var s_mon = toInt(fm.nfee_mon.value);
		var s_day = toInt(fm.nfee_day.value);

		if(obj==fm.s_pp_gu){ //선납금납입방식
			if(fm.s_pp_gu.value == '2'){
				fm.pded_amt.value = parseDecimal(Math.round(pp/mon));
				fm.tpded_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.pded_amt.value)) * (r_mon + r_day/30)));
				fm.rfee_amt.value = parseDecimal(Math.round(pp - toInt(parseDigit(fm.tpded_amt.value))));		

				fm.tfee_amt.value = parseDecimal(pp+(fee*mon));				
				fm.mfee_amt.value = parseDecimal(toInt(parseDigit(fm.tfee_amt.value)) / mon);
				fm.trfee_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30)));				
				if(fm.fee_chk.value == '1')
					fm.dft_amt.value = '0';
				else 
					fm.dft_amt.value = parseDecimal(toInt(parseDigit(fm.trfee_amt.value))*toInt(fm.dft_int.value)/100);
			}else if(fm.s_pp_gu.value == '1'){
				fm.pded_amt.value = '0';
				fm.tpded_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.pded_amt.value)) * (r_mon + r_day/30)));
				fm.rfee_amt.value = parseDecimal(Math.round(pp - toInt(parseDigit(fm.tpded_amt.value))));		

				fm.tfee_amt.value = parseDecimal(fee*mon);				
				fm.mfee_amt.value = parseDecimal(toInt(parseDigit(fm.tfee_amt.value)) / mon);
				fm.trfee_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30)));
				if(fm.fee_chk.value == '1')
					fm.dft_amt.value = '0';
				else 
					fm.dft_amt.value = parseDecimal(toInt(parseDigit(fm.trfee_amt.value))*toInt(fm.dft_int.value)/100);
			}else{
				fm.s_pp_gu[0].selected = true;
			}		
		}
		else if(obj==fm.pded_amt){ //선납금월공제액
			if(fm.s_pp_gu.value == '2'){
				fm.tpded_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.pded_amt.value)) * (r_mon + r_day/30)));
			}else{
//				alert('3개월치 대여료 선납식는 선납금 월공제액이 없습니다.');
				fm.pded_amt.value = '0';
				fm.tpded_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.pded_amt.value)) * (r_mon + r_day/30)));
			}
			fm.rfee_amt.value = parseDecimal(Math.round(pp - toInt(parseDigit(fm.tpded_amt.value))));		
		}
		else if(obj==fm.tpded_amt){ //선납금공제총액
			fm.rfee_amt.value = parseDecimal(pp - toInt(parseDigit(fm.tpded_amt.value)));		
		}
		else if(obj==fm.fee_amt || obj==fm.nfee_mon || obj==fm.nfee_day){ //미납월대여료
			fm.nfee_amt.value = parseDecimal(fee * (s_mon + s_day/30) );	
//			fm.no_v_amt.value = parseDecimal(toInt(parseDigit(fm.nfee_amt.value)) * 0.1);	
		}
		else if(obj==fm.tfee_amt){ //대여료총액
			fm.mfee_amt.value = parseDecimal(toInt(parseDigit(fm.tfee_amt.value)) / mon);
			fm.trfee_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30)));
			if(fm.fee_chk.value == '1')
				fm.dft_amt.value = '0';
			else 
				fm.dft_amt.value = parseDecimal(toInt(parseDigit(fm.trfee_amt.value))*toInt(fm.dft_int.value)/100);
		}
		else if(obj==fm.mfee_amt || obj==fm.rcon_mon || obj==fm.rcon_day || obj==fm.dft_int){ //환산월평균대여료
			fm.trfee_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30)));
			if(fm.fee_chk.value == '1')
				fm.dft_amt.value = '0';
			else 
				fm.dft_amt.value = parseDecimal(toInt(parseDigit(fm.trfee_amt.value))*toInt(fm.dft_int.value)/100);
		}		

//		fm.fdft_amt.value = parseDecimal(bak_th_rnd(toInt(parseDigit(fm.dft_amt.value))+toInt(parseDigit(fm.nfee_amt.value))-toInt(parseDigit(fm.rfee_amt.value))-toInt(parseDigit(fm.grt_amt.value))+toInt(parseDigit(fm.no_v_amt.value))));	
		fm.fdft_amt.value = parseDecimal(bak_th_rnd(toInt(parseDigit(fm.dft_amt.value))+toInt(parseDigit(fm.nfee_amt.value))-toInt(parseDigit(fm.rfee_amt.value))-toInt(parseDigit(fm.grt_amt.value))));	
		fm.fdft_dc_amt.value = parseDecimal(toInt(parseDigit(fm.fdft_dc_amt.value)));		
		if(fm.no_dft_yn.checked == true)
			fm.fdft_amt2.value = '0';
		else
			fm.fdft_amt2.value = parseDecimal(toInt(parseDigit(fm.fdft_amt.value)) - toInt(parseDigit(fm.fdft_dc_amt.value)));
			
	}

	//면제여부 선택
	function check_free(){
		var fm = document.form1;
		if(fm.no_dft_yn.checked == true)
			fm.fdft_amt2.value = '0';
		else
			set_tot_dft_amt();
	}

	//정산내역 셋팅
	function set_tot_dft_amt(){
		var fm = document.form1;
		fm.fdft_dc_amt.value = parseDecimal(toInt(parseDigit(fm.fdft_dc_amt.value)));		
		if(fm.no_dft_yn.checked == true)
			fm.fdft_amt2.value = '0';
		else
			fm.fdft_amt2.value = parseDecimal(toInt(parseDigit(fm.fdft_amt.value)) - toInt(parseDigit(fm.fdft_dc_amt.value)));
	}

	//실이용기간 계산
	function set_mon_day(){
		var fm = document.form1;
		fm.action='cls_nodisplay.jsp?rent_start_dt='+fm.rent_start_dt.value+'&cls_dt='+fm.cls_dt.value;
		fm.target='i_no';
		fm.submit();		
	}		
		
	//처음 셋팅하기
	function set_cls(){
		var fm = document.form1;
		var pp = toInt(fm.h_pp_amt.value);
		var mon = toInt(fm.h_mon.value);
		var r_mon = toInt(fm.h_r_mon.value);
		var r_day = toInt(fm.h_r_day.value);		
		var fee = toInt(parseDigit(fm.fee_amt.value));		
		var s_mon = toInt(fm.nfee_mon.value);
		var s_day = toInt(fm.nfee_day.value);		
		
		fm.pp_amt.value = parseDecimal(pp);		

		if(fm.s_pp_gu.value == '2'){
			fm.pded_amt.value 	= parseDecimal(pp/mon);
		}else{
			fm.pded_amt.value 	= parseDecimal(0);
		}
		fm.tpded_amt.value	= parseDecimal(toInt(parseDigit(fm.pded_amt.value)) * (r_mon + r_day/30) );
		fm.rfee_amt.value 	= parseDecimal(pp - toInt(parseDigit(fm.tpded_amt.value)));
		
		fm.nfee_amt.value = parseDecimal(Math.round(fee * (s_mon + s_day/30)));
		
		if(r_day > 0){
			fm.rcon_mon.value = mon-r_mon-1;
			fm.rcon_day.value = 30-r_day;
		}else{
			fm.rcon_mon.value = mon-r_mon;
		}
		fm.trfee_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30)));
		fm.dft_int.value = 20;
		fm.dft_amt.value = parseDecimal(Math.round(toInt(parseDigit(fm.trfee_amt.value))*toInt(fm.dft_int.value)/100));

		if(fm.fee_chk.value == '1') fm.dft_amt.value = '0';
		
		fm.fdft_amt.value = parseDecimal(bak_th_rnd(toInt(parseDigit(fm.dft_amt.value))+toInt(parseDigit(fm.nfee_amt.value))-toInt(parseDigit(fm.rfee_amt.value))));
		fm.fdft_dc_amt.value = '0';		
		fm.fdft_amt2.value = parseDecimal(toInt(parseDigit(fm.fdft_amt.value)) - toInt(parseDigit(fm.fdft_dc_amt.value)));	

	}