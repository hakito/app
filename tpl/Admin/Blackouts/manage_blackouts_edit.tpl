<form id="editBlackoutForm" class="form-inline" role="form" method="post">
	<div id="updateBlackout" class="row p-4">
		<div class="form-group col-6 d-flex align-items-center gap-1">
			<label class="fw-bold" for="updateStartDate">{translate key=BeginDate}</label>
			<input type="text" id="updateStartDate" class="form-control form-control-sm dateinput"
				value="{formatdate date=$BlackoutStartDate}" />
			<input {formname key=BEGIN_DATE} id="formattedUpdateStartDate" type="hidden"
				value="{formatdate date=$BlackoutStartDate key=system}" />
			<input {formname key=BEGIN_TIME} type="text" id="updateStartTime"
				class="form-select form-select-sm w-auto dateinput timepicker"
				value="{formatdate date=$BlackoutStartDate format='h:i A'}" />
		</div>

		<div class="form-group col-6 d-flex align-items-center gap-1">
			<label class="fw-bold" for="updateEndDate">{translate key=EndDate}</label>
			<input type="text" id="updateEndDate" class="form-control form-control-sm dateinput" size="10"
				value="{formatdate date=$BlackoutEndDate}" />
			<input {formname key=END_DATE} type="hidden" id="formattedUpdateEndDate"
				value="{formatdate date=$BlackoutEndDate key=system}" />
			<input {formname key=END_TIME} type="text" id="updateEndTime"
				class="form-select form-select-sm w-auto dateinput timepicker"
				value="{formatdate date=$BlackoutEndDate format='h:i A'}" />
		</div>

		<div class="form-group col-12 blackouts-edit-resources border rounded my-2">
			<label class="fw-bold">{translate key=Resources}</label>
			<div class="row">
				{foreach from=$Resources item=resource}
					{assign var=checked value=""}
					{if in_array($resource->GetId(), $BlackoutResourceIds)}
						{assign var=checked value="checked='checked'"}
					{/if}
					<div class="resourceItem col-12 col-sm-6">
						<div class="form-check">
							<input class="form-check-input" {formname key=RESOURCE_ID  multi=true} type="checkbox"
								value="{$resource->GetId()}" {$checked} id="r{$resource->GetId()}" />
							<label class="form-check-label" for="r{$resource->GetId()}">{$resource->GetName()}</label>
						</div>
					</div>
				{/foreach}
			</div>
		</div>

		<div class="col-12">
			<div class="form-group d-flex align-items-center gap-1 mb-2">
				<label class="fw-bold" for="blackoutReason">{translate key=Reason}<i
						class="bi bi-asterisk text-danger align-top" style="font-size: 0.5rem;"></i></label>
				<input {formname key=SUMMARY} type="text" id="blackoutReason" required
					class="form-control form-control-sm w-auto required has-feedback" value="{$BlackoutTitle}" />
				{*<i class="bi bi-asterisk form-control-feedback" data-bv-icon-for="blackoutReason"></i>*}
			</div>
		</div>

		<div class="mb-2">
			{control type="RecurrenceControl" RepeatTerminationDate=$RepeatTerminationDate prefix='edit'}
		</div>

		<div class="form-group col-12 mb-2">
			<div class="form-check form-check-inline">
				<input class="form-check-input" {formname key=CONFLICT_ACTION} type="radio" id="bookAroundUpdate"
					name="existingReservations" checked="checked" value="{ReservationConflictResolution::BookAround}" />
				<label class="form-check-label" for="bookAroundUpdate">{translate key=BlackoutAroundConflicts}</label>
			</div>
			<div class="form-check form-check-inline">
				<input class="form-check-input" {formname key=CONFLICT_ACTION} type="radio" id="notifyExistingUpdate"
					name="existingReservations" value="{ReservationConflictResolution::Notify}" />
				<label class="form-check-label" for="notifyExistingUpdate">{translate key=BlackoutShowMe}</label>
			</div>
			<div class="form-check form-check-inline">
				<input class="form-check-input" {formname key=CONFLICT_ACTION} type="radio" id="deleteExistingUpdate"
					name="existingReservations" value="{ReservationConflictResolution::Delete}" />
				<label class="form-check-label"
					for="deleteExistingUpdate">{translate key=BlackoutDeleteConflicts}</label>
			</div>
		</div>

		<div id="update-blackout-buttons" class="col-12 clearfix">
			<div class="float-end">
				<button type="button" class="btn btn-outline-secondary" id="cancelUpdate">
					{translate key='Cancel'}
				</button>
				{if $IsRecurring}
					<button type="button" class="btn btn-success save btnUpdateThisInstance">
						<i class="bi bi-check-circle-fill"></i>
						{translate key='ThisInstance'}
					</button>
					<button type="button" class="btn btn-success save btnUpdateAllInstances">
						<i class="bi bi-check2-all"></i>
						{translate key='AllInstances'}
					</button>
				{else}
					<button type="button" class="btn btn-success save update btnUpdateAllInstances">
						<i class="bi bi-check-circle-fill"></i>
						{translate key='Update'}
					</button>
				{/if}

			</div>
		</div>

		<input type="hidden" {formname key=BLACKOUT_INSTANCE_ID} value="{$BlackoutId}" />
		<input type="hidden" {formname key=SERIES_UPDATE_SCOPE} class="hdnSeriesUpdateScope"
			value="{SeriesUpdateScope::FullSeries}" />
	</div>
	{csrf_token}
</form>

<script type="text/javascript">
	$(function() {
		var recurOpts = {
			repeatType: '{$RepeatType}',
			repeatInterval: '{$RepeatInterval}',
			repeatMonthlyType: '{$RepeatMonthlyType}',
			repeatWeekdays: [{foreach from=$RepeatWeekdays item=day}{$day}, {/foreach}],
			customRepeatExclusions: ['{formatdate date=$BlackoutStartDate key=system}']
		};

		var recurrence = new Recurrence(recurOpts, {}, 'edit');
		recurrence.init();
		{foreach from=$CustomRepeatDates item=date}
			recurrence.addCustomDate('{format_date date=$date key=system timezone=$Timezone}', '{format_date date=$date timezone=$Timezone}');
		{/foreach}
	});
</script>

{control type="DatePickerSetupControl" ControlId="updateStartDate" AltId="formattedUpdateStartDate"}
{control type="DatePickerSetupControl" ControlId="updateEndDate" AltId="formattedUpdateEndDate"}
{control type="DatePickerSetupControl" ControlId="editEndRepeat" AltId="editformattedEndRepeat"}
{control type="DatePickerSetupControl" ControlId="editRepeatDate" AltId="editformattedRepeatDate"}